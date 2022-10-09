@IsTest
private class HP_HospitalSearchControllerTest {
    @IsTest
    static void shouldClearResults() {
        HP_HospitalSearchController controller = new HP_HospitalSearchController();
        controller.numberOfRecords = 10;
        HP_HospitalWrapper wrapper = new HP_HospitalWrapper();
        wrapper.street = 'Mazowiecka 33';
        wrapper.name = 'Marian hospital';
        wrapper.fax_number = 23456543;
        wrapper.no_ambulances = 2;
        List<HP_HospitalWrapper> hospitalList = new List<HP_HospitalWrapper>();
        hospitalList.add(wrapper);

        Test.startTest();
        controller.clearResults();
        Test.stopTest();

        System.assertEquals(controller.numberOfRecords, 0, 'Number Of Records should equal 0');
        System.assertEquals(controller.hospitalList.size(), 0, 'Doctor List Size should equal 0');
    }

    @IsTest
    static void shouldDeleteHospital() {
        HP_HospitalSearchController controller = new HP_HospitalSearchController();
        HP_HospitalWrapper wrapper = new HP_HospitalWrapper();
        wrapper.street = 'Mazowiecka 33';
        wrapper.name = 'Marian hospital';
        wrapper.fax_number = 23456543;
        wrapper.no_ambulances = 2;
        wrapper.id = 'a017Q056713FgLiQAK';
        wrapper.country = 'Poland';

        HP_HospitalWrapper hospital = new HP_HospitalWrapper();
        hospital.name = 'Mazowiecka 33';
        hospital.city = 'Marian hospital';
        hospital.country = 'Poland';

        List<HP_HospitalWrapper> hospitalList = new List<HP_HospitalWrapper>();
        hospitalList.add(wrapper);

        controller.hospitalList = hospitalList;
        controller.hospital = hospital;
        controller.deleteHospitalId = wrapper.id;

        Test.startTest();
        Test.setMock(WebServiceMock.class, new HP_SingleRequestMockSOAP('deleteMethod'));
        controller.deleteHospital();
        Test.stoptest();

        system.assert(ApexPages.getMessages().get(0).getDetail().contains('Successfully deleted'));
    }

    @IsTest
    static void shouldDeleteHospitalNegative() {
        HP_HospitalSearchController controller = new HP_HospitalSearchController();
        HP_HospitalWrapper wrapper = new HP_HospitalWrapper();
        wrapper.street = 'Mazowiecka 33';
        wrapper.name = 'Marian hospital';
        wrapper.fax_number = 23456543;
        wrapper.no_ambulances = 2;
        wrapper.id = 'a017Q056713FgLiQAK';
        wrapper.country = 'Poland';

        HP_HospitalWrapper hospital = new HP_HospitalWrapper();
        hospital.name = 'Mazowiecka 33';
        hospital.city = 'Marian hospital';
        hospital.country = 'Poland';

        List<HP_HospitalWrapper> hospitalList = new List<HP_HospitalWrapper>();
        hospitalList.add(wrapper);

        controller.hospitalList = hospitalList;
        controller.hospital = hospital;
        controller.deleteHospitalId = wrapper.id;

        Test.startTest();
        controller.deleteHospital();
        Test.stoptest();

        system.assert(ApexPages.getMessages().get(0).getDetail().contains('An error occurred'));
    }

    @IsTest
    static void shouldAddNewHospital() {
        HP_HospitalSearchController controller = new HP_HospitalSearchController();
        HP_HospitalWrapper hospitalToAdd = new HP_HospitalWrapper();
        hospitalToAdd.street = 'Mazowiecka 33';
        hospitalToAdd.name = 'Marian hospital';
        hospitalToAdd.fax_number = 23456543;
        hospitalToAdd.no_ambulances = 2;
        hospitalToAdd.id = 'a017Q056713FgLiQAK';

        controller.hospitalToAdd = hospitalToAdd;

        Test.startTest();
        Test.setMock(WebServiceMock.class, new HP_SingleRequestMockSOAP('insertMethod'));
        controller.addNewHospital();
        Test.stoptest();

        system.assert(ApexPages.getMessages().get(0).getDetail().contains('Successfully added'));
    }

    @IsTest
    static void shouldAddNewHospitalNegative() {
        HP_HospitalSearchController controller = new HP_HospitalSearchController();
        HP_HospitalWrapper hospitalToAdd = new HP_HospitalWrapper();
        hospitalToAdd.street = 'Mazowiecka 33';
        hospitalToAdd.name = 'Marian hospital';
        hospitalToAdd.fax_number = 23456543;
        hospitalToAdd.no_ambulances = 2;
        hospitalToAdd.phone = '55hjs8';
        hospitalToAdd.id = 'a017Q056713FgLiQAK';

        controller.hospitalToAdd = hospitalToAdd;

        Test.startTest();
        controller.addNewHospital();
        Test.stoptest();

        system.assert(ApexPages.getMessages().get(0).getDetail().contains('An error occurred'));
    }

    @IsTest
    static void shouldLoadHospitalToUpdate() {
        HP_HospitalSearchController controller = new HP_HospitalSearchController();
        HP_HospitalWrapper hospital1 = new HP_HospitalWrapper();
        hospital1.street = 'Mazowiecka 33';
        hospital1.name = 'Marian hospital';
        hospital1.fax_number = 23456543;
        hospital1.no_ambulances = 2;
        hospital1.phone = '55hjs8';
        hospital1.id = 'a017Q056713FgLiQAK';

        List<HP_HospitalWrapper> hospitalList = new List<HP_HospitalWrapper>();
        hospitalList.add(hospital1);

        controller.hospitalList = hospitalList;
        controller.updateHospitalIdLoadData = 'a017Q056713FgLiQAK';

        Test.startTest();
        controller.loadHospitalToUpdate();
        Test.stoptest();

        system.assertEquals(controller.hospitalToUpdate, hospital1);
    }

    @IsTest
    static void shouldUpdateHospital() {
        HP_HospitalSearchController controller = new HP_HospitalSearchController();
        HP_HospitalWrapper hospitalToUpdate = new HP_HospitalWrapper();
        hospitalToUpdate.street = 'Mazowiecka 33';
        hospitalToUpdate.name = 'Marian hospital';
        hospitalToUpdate.fax_number = 23456543;
        hospitalToUpdate.no_ambulances = 2;
        hospitalToUpdate.id = 'a017Q056713FgLiQAK';
        hospitalToUpdate.country = 'Poland';
        hospitalToUpdate.phone = '455233433';

        controller.hospitalToUpdate = hospitalToUpdate;
        ApexPages.CurrentPage().getParameters().put('hospitalToUpdateParam', 'a017Q056713FgKKKK');

        Test.startTest();
        Test.setMock(WebServiceMock.class, new HP_SingleRequestMockSOAP('updateMethod'));
        controller.updateHospital();
        Test.stoptest();
        system.assert(ApexPages.getMessages().get(0).getDetail().contains('Successfully updated'));
    }

    @IsTest
    static void shouldUpdateHospitalNegative() {
        HP_HospitalSearchController controller = new HP_HospitalSearchController();
        HP_HospitalWrapper hospitalToUpdate = new HP_HospitalWrapper();
        hospitalToUpdate.street = 'Mazowiecka 33';
        hospitalToUpdate.name = 'Marian hospital';
        hospitalToUpdate.phone = '';

        controller.hospitalToUpdate = hospitalToUpdate;
        ApexPages.CurrentPage().getParameters().put('hospitalToUpdateParam', '');
        Test.startTest();
        controller.updateHospital();
        Test.stoptest();
        system.assert(ApexPages.getMessages().get(0).getDetail().contains('An error occurred'));
    }

    @IsTest
    static void shouldSearchHospitals() {
        HP_HospitalSearchController controller = new HP_HospitalSearchController();
        HP_HospitalWrapper wrapper = new HP_HospitalWrapper();
        wrapper.street = 'Mazowiecka 33';
        wrapper.name = 'Marian hospital';
        wrapper.fax_number = 23456543;
        wrapper.no_ambulances = 2;
        wrapper.id = 'a017Q056713FgLiQAK';
        wrapper.country = 'Poland';

        HP_HospitalWrapper hospital = new HP_HospitalWrapper();
        hospital.name = 'Mazowiecka 33';
        hospital.city = 'Marian hospital';
        hospital.country = 'Poland';

        List<HP_HospitalWrapper> hospitalList = new List<HP_HospitalWrapper>();
        hospitalList.add(wrapper);

        controller.hospitalList = hospitalList;
        controller.hospital = hospital;
        controller.deleteHospitalId = wrapper.id;
        controller.numberOfRecords = 0;

        Test.startTest();
        Test.setMock(WebServiceMock.class, new HP_SingleRequestMockSOAP('searchMethod'));
        controller.searchHospitals();
        Test.stoptest();

        system.assertEquals(controller.numberOfRecords,1);
    }

    @IsTest
    static void shouldSearchHospitalsNegative() {
        HP_HospitalSearchController controller = new HP_HospitalSearchController();
        HP_HospitalWrapper wrapper = new HP_HospitalWrapper();
        wrapper.street = 'Mazowiecka 33';
        wrapper.name = 'Marian hospital';
        wrapper.fax_number = 23456543;
        wrapper.no_ambulances = 2;
        wrapper.id = 'a017Q056713FgLiQAK';
        wrapper.country = 'Poland';

        HP_HospitalWrapper hospital = new HP_HospitalWrapper();
        hospital.name = 'Muszynska';
        hospital.city = 'Stefan';
        hospital.country = 'Slovakia';

        List<HP_HospitalWrapper> hospitalList = new List<HP_HospitalWrapper>();
        hospitalList.add(wrapper);

        controller.hospitalList = hospitalList;
        controller.hospital = hospital;
        controller.deleteHospitalId = wrapper.id;
        controller.numberOfRecords = 0;

        Test.startTest();
        Test.setMock(WebServiceMock.class, new HP_SingleRequestMockSOAP('searchMethodNegative'));
        controller.searchHospitals();
        Test.stoptest();

        system.assertNotEquals(controller.numberOfRecords,1);
    }

    @IsTest
    static void shouldChceckIfRequiredPhoneFieldsArePresent() {
        HP_HospitalSearchController controller = new HP_HospitalSearchController();
        HP_HospitalWrapper hospitalToUpdate = new HP_HospitalWrapper();
        hospitalToUpdate.street = 'Mazowiecka 33';
        hospitalToUpdate.name = 'Marian hospital';
        hospitalToUpdate.fax_number = 23456543;
        hospitalToUpdate.no_ambulances = 2;
        hospitalToUpdate.id = 'a017Q056713FgLiQAK';
        hospitalToUpdate.country = 'Poland';
        hospitalToUpdate.phone = '';

        controller.hospitalToUpdate = hospitalToUpdate;

        Test.startTest();
        controller.chceckIfRequiredFieldsArePresent();
        Test.stoptest();

        system.assert(ApexPages.getMessages().get(0).getDetail().contains('cannot be empty'));
    }

    @IsTest
    static void shouldChceckIfRequiredNameFieldsArePresent() {
        HP_HospitalSearchController controller = new HP_HospitalSearchController();
        HP_HospitalWrapper hospitalToUpdate = new HP_HospitalWrapper();
        hospitalToUpdate.street = 'Mazowiecka 33';
        hospitalToUpdate.name = '';
        hospitalToUpdate.fax_number = 23456543;
        hospitalToUpdate.no_ambulances = 2;
        hospitalToUpdate.id = 'a017Q056713FgLiQAK';
        hospitalToUpdate.country = 'Poland';

        controller.hospitalToUpdate = hospitalToUpdate;

        Test.startTest();
        controller.chceckIfRequiredFieldsArePresent();
        Test.stoptest();

        system.assert(ApexPages.getMessages().get(0).getDetail().contains('cannot be empty'));
    }

}