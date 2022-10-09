@IsTest
public class HP_SingleRequestMock2SOAP implements WebServiceMock {

    public String mode;

    public HP_SingleRequestMock2SOAP(String mode) {
        this.mode = mode;
    }

    public void doInvoke(
            Object stub,
            Object request,
            Map<String, Object> response,
            String endpoint,
            String soapAction,
            String requestName,
            String responseNS,
            String responseName,
            String responseType) {

        if (mode == 'searchMethod') {
            soapSforceComSchemasClassHsSoapcru.getHospitalListResponse_element searchMethod =
                    new soapSforceComSchemasClassHsSoapcru.getHospitalListResponse_element();
            response.put('response_x', searchMethod);
        }
//
//        else {
//            soapSforceComSchemasClassHsSoapcru.deleteHospitalResponse_element operation = new soapSforceComSchemasClassHsSoapcru.deleteHospitalResponse_element();
////            responseElement.AgreementID = 344;
//            System.debug(operation);
//            response.put('response_x', operation);
//
//        }
    }

    public class AMock {
        public String mode;

        public AMock(String mode) {
            this.mode = mode;
        }

        public void doInvoke(
                Object stub, Object request, Map<String, Object> response,
                String endpoint, String soapAction, String requestName,
                String responseNS, String responseName, String responseType) {


            if (mode == 'insertMethod') {
                soapSforceComSchemasClassHsSoapcru.insertHospitalResponse_element operation =
                        new soapSforceComSchemasClassHsSoapcru.insertHospitalResponse_element();
                response.put('response_x', operation);
            }

            else if (mode == 'searchMethod') {
                soapSforceComSchemasClassHsSoapcru.getHospitalListResponse_element searchMethod =
                        new soapSforceComSchemasClassHsSoapcru.getHospitalListResponse_element();
                response.put('response_x', searchMethod);
            }

            else if (mode == 'deleteMethod') {
                soapSforceComSchemasClassHsSoapcru.deleteHospitalResponse_element deleteMethod =
                        new soapSforceComSchemasClassHsSoapcru.deleteHospitalResponse_element();

                response.put('response_x', deleteMethod);
            }

        }
    }

    public class BMock {

        public String mode;

        public BMock(String mode) {
            this.mode = mode;
        }

        public void doInvoke(
                Object stub, Object request, Map<String, Object> response,
                String endpoint, String soapAction, String requestName,
                String responseNS, String responseName, String responseType) {
            if (mode == 'insertMethod') {
                soapSforceComSchemasClassHsSoapcru.insertHospitalResponse_element operation =
                        new soapSforceComSchemasClassHsSoapcru.insertHospitalResponse_element();
                response.put('response_x', operation);
            }

            else if (mode == 'deleteMethod') {
                soapSforceComSchemasClassHsSoapcru.deleteHospitalResponse_element deleteMethod =
                        new soapSforceComSchemasClassHsSoapcru.deleteHospitalResponse_element();

                response.put('response_x', deleteMethod);
            }

            else if (mode == 'searchMethod') {
                soapSforceComSchemasClassHsSoapcru.getHospitalListResponse_element searchMethod =
                        new soapSforceComSchemasClassHsSoapcru.getHospitalListResponse_element();
                response.put('response_x', searchMethod);
            }

        }
    }
}