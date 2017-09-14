Bahmni.ConceptSet.FormConditions.rules = {
    'Place of the visit': function (formName, formFieldValues) {
        var conditions = {enable: [], disable: []};
	var otherReasonLine = "Other";
        var conditionConcept = formFieldValues['Place of the visit'];
        if (conditionConcept == 'Other') {
            conditions.enable.push("If other, specify:")
        } else {
            conditions.disable.push("If other, specify:")
        }
	return conditions;
    },
    'Change in diagnosis': function (formName, formFieldValues) {
        var conditions = {
            show: [],
            hide: []
        };

        var en4Drugs = "Diagnosis block";
        var result = formFieldValues['Change in diagnosis'];
        if (result == "1") {
            conditions.show.push( en4Drugs);
        } else {
            conditions.hide.push( en4Drugs);
        }
        return conditions;
    },

    'Referral Out List': function (formName, formFieldValues) {
        var conceptToEnable = "Other specialist";
        var conditions = {enable: [], disable: []};
        var Referral = formFieldValues['Referral Out List'];
        if (Referral && (Referral == "Other" || Referral.value == "Other")) {
            conditions.enable.push(conceptToEnable)
        } else {
            conditions.disable.push(conceptToEnable)
        }
        return conditions;
    },

  'History of target organ damage' : function (formName, formFieldValues) {
        var conditions = {enable: [], disable: []};
        var variable_taken = formFieldValues['History of target organ damage'];

        if (variable_taken == "heart failure(HF)") {
                conditions.enable.push("EF %")
        } else {
                conditions.disable.push("EF %")
            }
        return conditions;
    },
    'Ischemic heart disease/CAD' : function (formName, formFieldValues) {
        var conditions = {enable: [], disable: []};
        var variable_name =formFieldValues['Ischemic heart disease/CAD'];
        if (variable_name && variable_name == "Angina") {
               	conditions.enable.push("AMI")
		conditions.disable.push("Date(CABG)","Date(PTCA)")
	}
	else if (variable_name && variable_name == "CABG") {
                conditions.enable.push("Date(CABG)")
		conditions.disable.push("AMI","Date(PTCA)")
        }
	else if (variable_name && variable_name == "Angioplasty(PTCA)") {
                conditions.enable.push("Date(PTCA)")
		conditions.disable.push("AMI","Date(CABG)")
        }
	else {
		conditions.disable.push("AMI","Date(CABG)","Date(PTCA)")
	}
	return conditions;
    },
    'Complications block(baseline)': function (formName, formFieldValues) {
        var conceptToEnable = "Other";
        var conditions = {enable: [], disable: []};
        var delivery_mode_2 = formFieldValues['Complications block(baseline)'];
        if (delivery_mode_2 && (delivery_mode_2 == "Other" || delivery_mode_2.value == "Other")) {
            conditions.enable.push(conceptToEnable)
        } else {
            conditions.disable.push(conceptToEnable)
        }
        return conditions;
    },
};
