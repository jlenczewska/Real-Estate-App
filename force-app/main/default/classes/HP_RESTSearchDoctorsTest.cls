@IsTest(SeeAllData=true)
private class HP_RESTSearchDoctorsTest {

    public static RestRequest req;
    public static RestResponse res;
    public static HP_RESTCrudSearchController controller;
    public static String basicUrl = 'callout:Werka_Org/services/apexrest/Hs_Crud?';

    @IsTest
    private static void shouldClearResults() {
        HP_RESTCrudSearchController controller = new HP_RESTCrudSearchController();
        controller.numberOfRecords = 10;
        controller.offsetNumber = 0;
        HP_DoctorWrapperWerka wrapper = new HP_DoctorWrapperWerka();
        wrapper.email1 = 'email1@email.pl';
        wrapper.first_name = 'Marian';
        wrapper.last_name = 'Kowalski';
        wrapper.license_number = '34582456';
        List<HP_DoctorWrapperWerka> doctorList = new List<HP_DoctorWrapperWerka>();
        doctorList.add(wrapper);

        Test.startTest();
        controller.clearResults();
        Test.stopTest();

        System.assertEquals(controller.numberOfRecords, 0, 'Number Of Records should equal 0');
        System.assertEquals(controller.offsetNumber, 0, 'Offset number should equal 0');
        System.assertEquals(controller.doctorList.size(), 0, 'Doctor List Size should equal 0');
    }

    @IsTest
    private static void shouldGoToFirstPage() {
        HP_RESTCrudSearchController controller = new HP_RESTCrudSearchController();

        controller.offsetNumber = 20;
        controller.doctor = new HP_DoctorWrapperWerka();

        Test.startTest();
        controller.firstPage();
        Test.stopTest();

        System.assertEquals(controller.offsetNumber, 0, 'Offset number should equal 0');
    }

    @IsTest
    private static void shouldGoToPreviousPage() {
        HP_RESTCrudSearchController controller = new HP_RESTCrudSearchController();

        controller.offsetNumber = 20;
        controller.doctorsPerPageOptionsValue = 10;
        controller.doctor = new HP_DoctorWrapperWerka();

        Test.startTest();
        controller.previousPage();
        Test.stopTest();

        System.assertEquals(controller.offsetNumber, 10, 'Offset number should equal 10');
    }

    @IsTest
    private static void shouldGoToNextPage() {
        HP_RESTCrudSearchController controller = new HP_RESTCrudSearchController();

        controller.offsetNumber = 10;
        controller.doctorsPerPageOptionsValue = 10;
        controller.doctor = new HP_DoctorWrapperWerka();

        Test.startTest();
        controller.nextPage();
        Test.stopTest();

        System.assertEquals(controller.offsetNumber, 20, 'Offset number should equal 20');
    }

    @IsTest
    private static void shouldGoToLastPage() {
        HP_RESTCrudSearchController controller = new HP_RESTCrudSearchController();

        controller.numberOfRecords = 32;
        controller.doctorsPerPageOptionsValue = 10;
        controller.doctor = new HP_DoctorWrapperWerka();

        Test.startTest();
        controller.lastPage();
        Test.stopTest();

        System.assertEquals(controller.offsetNumber, 30, 'Offset number should equal 30');
    }

    @IsTest
    private static void shouldChangeRecordsPerPageTo10() {
        HP_RESTCrudSearchController controller = new HP_RESTCrudSearchController();
        controller.doctorsPerPageOptionsValue = 20;
        controller.offsetNumber = 20;

        Test.startTest();
        controller.changeRecordPerPageTo10();
        Test.stopTest();

        System.assertEquals(controller.doctorsPerPageOptionsValue, 10, 'Doctors per page should equal 10');
        System.assertEquals(controller.offsetNumber, 0, 'Offset number should equal 0');
    }

    @IsTest
    private static void shouldChangeRecordsPerPageTo20() {
        HP_RESTCrudSearchController controller = new HP_RESTCrudSearchController();
        controller.doctorsPerPageOptionsValue = 10;
        controller.offsetNumber = 20;

        Test.startTest();
        controller.changeRecordPerPageTo20();
        Test.stopTest();

        System.assertEquals(controller.doctorsPerPageOptionsValue, 20, 'Doctors per page should equal 20');
        System.assertEquals(controller.offsetNumber, 0, 'Offset number should equal 0');
    }

    @IsTest
    private static void shouldChangeRecordsPerPageTo50() {
        HP_RESTCrudSearchController controller = new HP_RESTCrudSearchController();
        controller.doctorsPerPageOptionsValue = 10;
        controller.offsetNumber = 20;

        Test.startTest();
        controller.changeRecordPerPageTo50();
        Test.stopTest();

        System.assertEquals(controller.doctorsPerPageOptionsValue, 50, 'Doctors per page should equal 50');
        System.assertEquals(controller.offsetNumber, 0, 'Offset number should equal 0');
    }

    @IsTest
    private static void shouldDeleteDoctorFromDatabase() {
        HP_RESTCrudSearchController controller = new HP_RESTCrudSearchController();
        HP_DoctorWrapperWerka wrapper = new HP_DoctorWrapperWerka();
        wrapper.email1 = 'markojutro@pp.pl';
        wrapper.id = 'a017Q000013FgLiQAK';

        List<HP_DoctorWrapperWerka> doctorWrapperList = new List<HP_DoctorWrapperWerka>();
        doctorWrapperList.add(wrapper);
        controller.doctorList = doctorWrapperList;

        controller.deleteDoctorId = 'a017Q000013FgLiQAK';


        HP_SingleRequestMockREST fakeResponse = new HP_SingleRequestMockREST(200, 'Complete', null, null);

        Test.startTest();
        Test.setMock(HttpCalloutMock.class, fakeResponse);
        controller.deleteDoctor();
        Test.stoptest();

        system.assert(ApexPages.getMessages().get(0).getDetail().contains(System.Label.HP_Successfully_removed));
    }

    @IsTest
    private static void shouldDeleteDoctorFromDatabaseNegative() {
        HP_RESTCrudSearchController controller = new HP_RESTCrudSearchController();
        HP_DoctorWrapperWerka wrapper = new HP_DoctorWrapperWerka();
        wrapper.email1 = 'markojutro@pp.pl';
        wrapper.id = 'a017Q000013FgLiQAK';

        List<HP_DoctorWrapperWerka> doctorWrapperList = new List<HP_DoctorWrapperWerka>();
        doctorWrapperList.add(wrapper);
        controller.doctorList = doctorWrapperList;

        controller.deleteDoctorId = 'a017Q000013FgLiQAK';

        HP_SingleRequestMockREST fakeResponse = new HP_SingleRequestMockREST(500, 'Server error', null, null);

        Test.startTest();
        Test.setMock(HttpCalloutMock.class, fakeResponse);
        controller.deleteDoctor();
        Test.stoptest();

        System.assert(!ApexPages.getMessages().get(0).getDetail().contains(System.Label.HP_Successfully_removed));
    }

    @IsTest
    private static void shouldUpdateDoctorInDatabase() {
        HP_RESTCrudSearchController controller = new HP_RESTCrudSearchController();
        HP_DoctorWrapperWerka wrapper = new HP_DoctorWrapperWerka();
        wrapper.email1 = 'email1@email.pl';
        wrapper.first_name = 'Dlabeki';
        wrapper.id = 'a017Q003313FgLiQAK';
        List<HP_DoctorWrapperWerka> doctorList = new List<HP_DoctorWrapperWerka>();
        doctorList.add(wrapper);
        controller.doctorToUpdate = wrapper;
        controller.doctorList = doctorList;

        HP_SingleRequestMockREST fakeResponse = new HP_SingleRequestMockREST(200, 'Complete', HP_REST_CRUD_Helper.serializedDoctorToUpdate(wrapper), null);

        Test.startTest();
        Test.setMock(HttpCalloutMock.class, fakeResponse);
        controller.updateDoctor();
        Test.stopTest();

        system.assert(ApexPages.getMessages().get(0).getDetail().contains(System.Label.HP_Successfully_updated));
    }

    @IsTest
    private static void shouldUpdateDoctorInDatabaseNegative() {
        HP_RESTCrudSearchController controller = new HP_RESTCrudSearchController();
        HP_DoctorWrapperWerka wrapper = new HP_DoctorWrapperWerka();
        wrapper.email1 = 'email1@email.pl';
        wrapper.first_name = 'Dlabeki';
        wrapper.id = 'a017Q003313FgLiQAK';
        List<HP_DoctorWrapperWerka> doctorList = new List<HP_DoctorWrapperWerka>();
        doctorList.add(wrapper);
        controller.doctorToUpdate = wrapper;
        controller.doctorList = doctorList;

        HP_SingleRequestMockREST fakeResponse = new HP_SingleRequestMockREST(500, 'Server error', HP_REST_CRUD_Helper.serializedDoctorToUpdate(wrapper), null);

        Test.startTest();
        Test.setMock(HttpCalloutMock.class, fakeResponse);
        controller.updateDoctor();
        Test.stopTest();

        system.assert(!ApexPages.getMessages().get(0).getDetail().contains(System.Label.HP_Successfully_updated));
    }

    @IsTest
    private static void shouldAddNewDoctor() {
        HP_RESTCrudSearchController controller = new HP_RESTCrudSearchController();
        HP_DoctorWrapperWerka wrapper = new HP_DoctorWrapperWerka();
        wrapper.email1 = 'email1@email.pl';
        wrapper.first_name = 'Marian';
        wrapper.last_name = 'Kowalski';
        wrapper.license_number = '34582456';

        controller.doctorToAdd = wrapper;

        HP_SingleRequestMockREST fakeResponse = new HP_SingleRequestMockREST(200, 'Created', HP_REST_CRUD_Helper.serializedDoctorToAdd(controller.doctorToAdd), null);

        Test.startTest();
        Test.setMock(HttpCalloutMock.class, fakeResponse);
        controller.addNewDoctor();
        Test.stopTest();

        system.assert(ApexPages.getMessages().get(0).getDetail().contains(System.Label.HP_Successfully_added_to_the_database));
    }

    @IsTest
    private static void shouldAddNewDoctorNegative() {
        HP_RESTCrudSearchController controller = new HP_RESTCrudSearchController();
        HP_DoctorWrapperWerka wrapper = new HP_DoctorWrapperWerka();
        wrapper.email1 = 'email1@email.pl';
        wrapper.first_name = 'Marian';
        wrapper.last_name = 'Kowalski';
        wrapper.license_number = '34582456';

        controller.doctorToAdd = wrapper;

        HP_SingleRequestMockREST fakeResponse = new HP_SingleRequestMockREST(500, 'Server error', HP_REST_CRUD_Helper.serializedDoctorToAdd(controller.doctorToAdd), null);

        Test.startTest();
        Test.setMock(HttpCalloutMock.class, fakeResponse);
        controller.addNewDoctor();
        Test.stopTest();

        system.assert(!ApexPages.getMessages().get(0).getDetail().contains(System.Label.HP_Successfully_added_to_the_database));
    }

    @IsTest
    private static void shouldDoctorToUpdateInformationLoad() {
        HP_RESTCrudSearchController controller = new HP_RESTCrudSearchController();
        HP_DoctorWrapperWerka wrapper = new HP_DoctorWrapperWerka();
        wrapper.email1 = 'email1@email.pl';
        wrapper.first_name = 'Marian';
        wrapper.last_name = 'Kowalski';
        wrapper.license_number = '34582456';
        List<HP_DoctorWrapperWerka> doctorList = new List<HP_DoctorWrapperWerka>();
        doctorList.add(wrapper);
        controller.doctorToUpdate = wrapper;
        controller.doctorList = doctorList;

        Test.startTest();
        controller.loadDoctorToUpdate();
        Test.stopTest();

        system.assert(controller.doctorToUpdate == wrapper);
    }

}