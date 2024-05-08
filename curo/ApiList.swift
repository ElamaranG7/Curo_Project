
import Foundation
import UIKit


struct ApiList {
    
    static let baseUrl = "http://localhost/curo/"
    
    
    
    static let ploginURL = baseUrl + "plogin.php?"
    static let dloginURL = baseUrl + "dlogin.php?"
    static let AddPatientURL = baseUrl+"add.php"
        static let FeatchingPatientURL = baseUrl + "featching_patient_dashboard.php"
        static let FeatchingNotifactionURL = baseUrl + "feach_notifactions.php"
        static let PatientDetailsURL = baseUrl+"patientdetailsfetch.php"
        static let DoctorDetailsURL = baseUrl+"featching_doctordetails.php"
        static let UpdateingPatientDetailURL = baseUrl+"updating_patient_details.php"
        static let DischargeFormURL = baseUrl+"featch_discharge_form.php"
        static let ReportsURL = baseUrl+"featch_reports.php?"
        static let PendingAppoinmentsURL = baseUrl+"printappoinment.php"
        static let ApprovedAppoinmentsURL = baseUrl+"apoapproved.php?"
        static let RejectedAppoinmentsURL = baseUrl+"rejected_appoinments.php"
        static let UploadingReportsURL = baseUrl+"upload.php"
        static let UploadingDischareFromURL = baseUrl+"discharge.php"
        static let UpdateAppointmentURL = baseUrl+"updated_appoinments.php"
        static let symptomsURL = baseUrl+"symptoms.php"
        static let appoinmentsBookingURL = baseUrl+"appoinments_bokking.php"
        static let appoinmentStatusURL = baseUrl+"checkap.php"
    
  
    
    
  
}

