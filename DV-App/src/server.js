// NodeJS imports
import { fileURLToPath } from "url";
import path from "path";
//import fs from "fs";
import handlebars from 'handlebars';

// External libraries
import Fastify from "fastify";
import fetch from "node-fetch";

// Initialize variables that are no longer available by default in Modules
const __filename = fileURLToPath(import.meta.url);
const __dirname = path.dirname(__filename);

// Require the fastify framework and instantiate it
const fastify = Fastify({
  // Set this to true for detailed logging
  logger: false,
  ignoreTrailingSlash: true,
});

// Setup our static files
fastify.register(import("@fastify/static"), {
  root: path.join(__dirname, "public"),
  prefix: "/" // optional: default '/'
});

// fastify-formbody lets us parse incoming forms
fastify.register(import("@fastify/formbody"));

/*
 * Simple API to allow the application to receive the configuration information needed for the widget
 */
fastify.get("/runtimeDetails", (req, reply) => {
  reply.send({"envId": process.env.ENVID, "dvPolicyId": process.env.DVPOLICYID, dvDomain: process.env.DVDOMAIN})
})

/************************
* DaVinci components
************************/

// Retrieve the token needed to invoke a Widget flow in the client
fastify.get("/getDvToken", (req, reply) => {
  getDVToken(dvToken => {
    reply.send({
      token: dvToken.access_token
    });
  });
});

// Get a Widget sdkToken
function getDVToken(cb) {
  
  // https://orchestrate-api.pingone.com/v1/company/<Company ID>/sdktoken
  const url = "https://orchestrate-api.pingone."+process.env.DVDOMAIN+"/v1/company/"+process.env.ENVID+"/sdktoken";
  console.log("Token Url: ", url)
  fetch(url, {
    headers: {
      "X-SK-API-KEY": process.env.DVAPIKEY
    },
    method: "GET"
  })
    .then(res => res.json())
    .then(data => cb(data))
    .catch(err => console.log("Error: ", err));
}

/************************
* End DaVinci components
************************/

// Run the server and report out to the logs
fastify.listen(
  { port: 4000, host: "0.0.0.0" },
  function (err, address) {
    if (err) {
      console.error(err);
      process.exit(1);
    }
    console.log(`Your app is listening on ${address}`);
    const incomingVars = {"envId": process.env.ENVID, "dvApiKey": process.env.DVAPIKEY, "dvPolicyId": process.env.DVPOLICYID}
    console.log("Incoming Vars: "+JSON.stringify(incomingVars))
  }
);