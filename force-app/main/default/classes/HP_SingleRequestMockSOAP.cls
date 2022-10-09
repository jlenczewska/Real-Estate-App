@IsTest
public class HP_SingleRequestMockSOAP implements WebServiceMock {

    public String mode;

    public HP_SingleRequestMockSOAP(String mode) {
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

        if (mode == 'insertMethod') {
            soapSforceComSchemasClassHsSoapcru.insertHospitalResponse_element operation =
                    new soapSforceComSchemasClassHsSoapcru.insertHospitalResponse_element();
            response.put('response_x', operation);
        }

        if (mode == 'deleteMethod') {
            soapSforceComSchemasClassHsSoapcru.deleteHospitalResponse_element deleteMethod =
                    new soapSforceComSchemasClassHsSoapcru.deleteHospitalResponse_element();
            response.put('response_x', deleteMethod);
        }

        if (mode == 'searchMethod') {

            List<soapSforceComSchemasClassHsSoapcru.HS_HospitalsDTO> results =
                    new List<soapSforceComSchemasClassHsSoapcru.HS_HospitalsDTO> ();

            soapSforceComSchemasClassHsSoapcru.HS_HospitalsDTO hospital_DTO =
                    new soapSforceComSchemasClassHsSoapcru.HS_HospitalsDTO();

            hospital_DTO.street = 'Mazowiecka 33';
            hospital_DTO.name = 'Marian hospital';
            hospital_DTO.fax_number = 23456543;
            hospital_DTO.no_ambulances = 2;
            hospital_DTO.id = 'a017Q056713FgLiQAK';
            hospital_DTO.country = 'Poland';

            soapSforceComSchemasClassHsSoapcru.getHospitalListResponse_element searchMethod =
                    new soapSforceComSchemasClassHsSoapcru.getHospitalListResponse_element();

            results.add(hospital_DTO);

            searchMethod.result = results;
            response.put('response_x', searchMethod);
        }

        if (mode == 'searchMethodNegative') {

            soapSforceComSchemasClassHsSoapcru.getHospitalListResponse_element searchMethod =
                    new soapSforceComSchemasClassHsSoapcru.getHospitalListResponse_element();
            response.put('response_x', searchMethod);
        }

        if (mode == 'updateMethod') {
            soapSforceComSchemasClassHsSoapcru.updateHospitalResponse_element updateMethod =
                    new soapSforceComSchemasClassHsSoapcru.updateHospitalResponse_element();
            response.put('response_x', updateMethod);
        }

    }
}