public with sharing class HP_REST_CRUD_Helper {

    public static Boolean checkIfOnlyNumbers(String field) {
        String fieldName = (field.split(':')[0]).replaceAll('"', '');
        String fieldValue = (field.split(':')[1]).replaceAll('"', '');

        if (!fieldValue.isNumeric()) {
            ApexPages.addmessage(new ApexPages.message(ApexPages.severity.WARNING, System.Label.HP_Only_numbers_are_allowed + ': ' + fieldName
                    .replaceAll('_', ' ')));
            return false;
        } else {
            return true;
        }
    }

    public static Boolean checkIfEmailHasCorrectEnd(String field) {

        String fieldValue = (field.split(':')[1]).replaceAll('"', '');

        if (!fieldValue.endsWith('.pl') && !fieldValue.endsWith('.com')) {
            ApexPages.addmessage(new ApexPages.message(ApexPages.severity.WARNING, System.Label.HP_Email_must_end_with));
            return false;
        } else {
            return true;
        }
    }

    public static String setMessageError(String errorBodyMessage) {
        if (errorBodyMessage.contains('Duplicate')) {
            return errorBodyMessage.split('"')[3].replaceAll('_', ' ');
        } else if (errorBodyMessage.contains('DUPLICATE')) {
            return System.Label.HP_Duplicate_value_found + ': ' + ((errorBodyMessage.split('duplicate value found:')[1].split('__c')[0])).removeStart(', ').replaceAll('_', ' ');
        } else if (errorBodyMessage.contains('STRING_TOO_LONG')) {
            return (errorBodyMessage.split('STRING_TOO_LONG')[1].split(':')[0]).removeStart(', ') + ': ' +
                    System.Label.HP_String_too_long + ': ' +
                    (errorBodyMessage.split('STRING_TOO_LONG')[1].split(':')[2]) ;
        } else if (errorBodyMessage.contains('NUMBER_OUTSIDE_VALID_RANGE')) {
            return (errorBodyMessage.split('NUMBER_OUTSIDE_VALID_RANGE')[1].split(':')[0]).removeStart(', ') + ': ' +
                    System.Label.HP_The_length_of_the_license_number_cannot_exceed_18_characters;
        } else if (errorBodyMessage.contains('cannot be converted from Text')) {
            return System.Label.HP_Incorrect_data_entered;
        } else if (errorBodyMessage.contains('FIELD_CUSTOM_VALIDATION_EXCEPTION')) {
            return ((errorBodyMessage.split('FIELD_CUSTOM_VALIDATION_EXCEPTION')[1].split(':')[0])).removeStart(', ');
        } else if (errorBodyMessage.contains('Argument cannot be null')) {
            return System.Label.HP_An_error_occurred_Please_refresh_the_page_and_try_again;
        } else if (errorBodyMessage.contains('INVALID_TYPE_ON_FIELD_IN_RECORD') || errorBodyMessage.contains('List has no rows for assignment to SObject')) {
            return System.Label.HP_Incorrect_data_in_the_license_number_field;
        } else {
            return System.Label.HP_Incorrect_data_entered;
        }
    }

    public static String getDoctorToUpdateId(List<HP_DoctorWrapperWerka> doctorList, HP_DoctorWrapperWerka doctorToUpdate) {
        for (HP_DoctorWrapperWerka doctor : doctorList) {
            if (doctor.license_number == doctorToUpdate.license_number) {
                return doctor.id;
            }
        }
        return null;
    }

    public static HP_DoctorWrapperWerka getDoctorToDeleteId(List<HP_DoctorWrapperWerka> doctorList, String deleteDoctorId) {
        for (HP_DoctorWrapperWerka doctor : doctorList) {
            if (doctor.Id == deleteDoctorId) {
                return doctor;
            }
        }
        return null;
    }

    public static String setConditionsToGetDoctors(List<HP_DoctorWrapperWerka> doctorList, HP_DoctorWrapperWerka doctor) {
        String conditions = '';

        if (doctorList.size() != 0) {
            doctorList.clear();
        }

        if (doctor.first_name != null && doctor.first_name.length() != 0) {
            conditions += 'first_name=' + doctor.first_name.replaceAll('\\s+', '');
        }

        if (doctor.last_name != null && doctor.last_name.length() != 0) {
            if (conditions.length() > 0) {
                conditions += '&';
            }
            conditions += 'last_name=' + doctor.last_name.replaceAll('\\s+', '');
        }

        if (doctor.email1 != null && doctor.email1.length() != 0) {
            if (conditions.length() > 0) {
                conditions += '&';
            }
            conditions += 'email1=' + doctor.email1.replaceAll('\\s+', '');
        }

        if (doctor.country1 != null && doctor.country1.length() != 0) {
            if (conditions.length() > 0) {
                conditions += '&';
            }
            conditions += 'country=' + doctor.country1.replaceAll('\\s+', '');
        }

        return conditions;
    }

    public static String serializedDoctorToAdd(HP_DoctorWrapperWerka doctorToAdd) {

        String jsonDoctor = JSON.serialize(doctorToAdd);
        String jsonDoctorWithoutNulls = '';

        for (String element : jsonDoctor.removeStart('{').removeEnd('}').split(',')) {
            if (!element.contains('null') && !element.contains('""')) {

                if (element.contains('license_number') || element.contains('phone')) {
                    Boolean isNumber = HP_REST_CRUD_Helper.checkIfOnlyNumbers(element);
                    if (isNumber) {
                        jsonDoctorWithoutNulls += element + ', ';
                    } else {
                        break;
                    }
                    continue;
                }

                else if (element.contains('email1')) {
                    Boolean hasCorrectEnd = HP_REST_CRUD_Helper.checkIfEmailHasCorrectEnd(element);
                    if (!hasCorrectEnd) {
                        jsonDoctorWithoutNulls += element + ', ';
                    }
                }
                jsonDoctorWithoutNulls += element + ', ';
            }
        }

        jsonDoctorWithoutNulls = jsonDoctorWithoutNulls.removeEnd(', ');
        jsonDoctorWithoutNulls = '{' + jsonDoctorWithoutNulls + '}';
        return jsonDoctorWithoutNulls;

    }

    public static String serializedDoctorToUpdate(HP_DoctorWrapperWerka doctorToUpdate) {
        String serializedDoctor = JSON.serialize(doctorToUpdate);
        String JsonDoctorWithoutNulls = '';

        for (String element : serializedDoctor.removeStart('{').removeEnd('}').split(',')) {
            if (!element.contains('Id') && !element.contains('""') && !element.contains('null')) {
                if (element.contains('license_number') || element.contains('phone')) {
                    Boolean isNumber = HP_REST_CRUD_Helper.checkIfOnlyNumbers(element);
                    if (isNumber) {
                        if (element.contains('phone')) {
                            JsonDoctorWithoutNulls += (element.split(':'))[0] + ':' + (element.split(':'))[1] + ', ';
                        } else {
                            JsonDoctorWithoutNulls += (element.split(':'))[0] + ':' + (element.split(':'))[1].replaceAll('"', '') + ', ';
                        }
                    } else {
                        return '';
                    }
                    continue;
                } else if (element.contains('date_of_birth') || element.contains('start_of_career')) {
                    String value = ((element.split(':'))[1].replaceAll('"', ''));
                    String dateConverted = value .split('-')[2] + '/' + value .split('-')[1] + '/' + value .split('-')[0];
                    JsonDoctorWithoutNulls += (element.split(':'))[0] + ':"' + dateConverted + '", ';
                } else {
                    JsonDoctorWithoutNulls += element + ', ';
                }
            }
        }
        JsonDoctorWithoutNulls = JsonDoctorWithoutNulls.removeEnd(', ');
        JsonDoctorWithoutNulls = '{' + JsonDoctorWithoutNulls + '}';
        return JsonDoctorWithoutNulls;
    }

}