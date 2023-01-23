startApp()

function startApp() {
    fetch("/runtimeDetails")
    .then(res => res.json())
    .then(data => {console.log(data); invokeWidget(data.envId, data.dvDomain, data.dvPolicyId, {}, false)})
    .catch(err => document.getElementById("log").innerText=err)
}

function invokeWidget(envId, domain, policyId, params, modal) {
  
  /** Get token from DV to begin Flow
  * Server-side component that swaps the DV API Key for the dvToken
  */  
  fetch("/getDvToken")
    .then(res => res.json())
    .then(data => {
      /**
       * Creates an instance of the widget with the following
       * @param {object} props - properties for the widget execution
       * @param {object} props.config - object containing the widget config
       * @param {string} props.config.method - Widget run method - { "runFlow" | "continueFlow" }
       * @param {string} props.config.apiRoot - URL of the SK Instance for this Flow
       * @param {string} props.config.accessToken - skToken from the fetch() response
       * @param {string} props.config.companyId - skCompanyId that contains the Flow
       * @param {string} props.config.policyId - PolicyId for the widget to run
       * @param {object} props.config.params - Parameters object to send into Flow - must be defined in Input Schema
       * @param {boolean} props.useModal - Present widget as a modal instead of embedded
       * @param {requestCallback} props.successCallback - The callback that handles the Success response
       * @param {requestCallback} props.errorCallback - The callback that handles the Error response
       * @param {requestCallback} props.onCloseModal - The callback that handles the modal close response (`useModal` == true)
       */
      var props = {
        config: {
          method: "runFlow",
          apiRoot: "https://auth.pingone."+domain+"/",
          accessToken: data.token,
          companyId: envId,
          policyId: policyId,        
          parameters: params
        },
        useModal: modal,
        successCallback,
        errorCallback,
        onCloseModal,
      };
      /*** Invoke DaVinci Widget ****/
      davinci.skRenderScreen(document.getElementById("dvwidget"), props);
    });
}

function successCallback(response) {
  document.getElementById("log").innerHTML="<pre>"+JSON.stringify(response.additionalProperties, null, 2)+"</pre>"
}

function errorCallback(error) {
  console.log(error);
  document.getElementById("log").innerText=JSON.stringify(error)
}

function onCloseModal() {
  console.log("onCloseModal");
}