// lib/core/constants.dart
class AppConstants {
  static const String appName = 'tawzif_platform';
  static const String baseUrl = 'https://job-portal-rcxk.onrender.com';

  // users_type
  static const String userTypeJobSeeker = 'job_seeker';
  static const String userTypeEmployer = 'employer';
  static const String userTypeAdmin = 'admin';

  // storage_keys
  static const String authTokenKey = 'auth_token';
  static const String userDataKey = 'user_data';
  static const String isFirstTimeKey = 'is_first_time';
}

class ApiEndpoints {
  //auth constant
  static const String login = '/api/accounts/login/';
  static const String register = '/api/accounts/register/';
  static const String logout = '/api/accounts/logout/';
  static const String profile = '/api/accounts/profile/';
  static const String users = '/api/accounts/users/';

  static const String changePassword = '/api/accounts/change-password/';
  static const String updateProfile = '/api/accounts/profile/update/';
  static const String updateEmployerProfile = '/api/accounts/profile/employer/';
  static const String updateJobSeekerProfile = '/api/accounts/profile/job-seeker/';

// Jobs
  static const String jobs = '/api/jobs/';
  static const String myJobs = '/api/jobs/my-jobs/';
  static const String createJob = '/api/jobs/create/';
  static const String jobBookmark = '/api/jobs/{job_id}/bookmark/';

  static const String jobDetail = '/api/jobs/'; // + {slug}
  static const String updateJob = '/api/jobs/{slug}/update/';
  static const String deleteJob = '/api/jobs/{slug}/delete/';
  static const String bookmarks = '/api/jobs/bookmarks/';
  static const String similarJobs = '/api/jobs/{job_id}/similar/';
  static const String jobCategories = '/api/jobs/categories/';
  static const String jobStatistics = '/api/jobs/statistics/';
  //jobs_alerts
  static const String jobAlerts = '/api/jobs/alerts/';
  static const String jobAlertDetail = '/api/jobs/alerts/{id}/';
  // Companies
  static const String companies = '/api/companies/';
  static const String myCompanies = '/api/companies/my-companies/';
  static const String createCompany = '/api/companies/create/';
  static const String followCompany = '/api/companies/{company_id}/follow/';

  static const String companyDetail = '/companies/'; // + {slug}
  static const String updateCompany = '/companies/{slug}/update/';
  static const String deleteCompany = '/companies/{slug}/delete/';
  static const String followedCompanies = '/companies/followed/';
  static const String companyJobs = '/companies/{company_id}/jobs/';
  static const String companyReviews = '/companies/{company_id}/reviews/';
  static const String createCompanyReview = '/companies/{company_id}/reviews/create/';
  static const String topCompanies = '/companies/top/';
  static const String companyStatistics = '/companies/statistics/';

//  Applications
  static const String applications = '/api/applications/';
  static const String myApplications = '/api/applications/my-applications/';
  static const String applyJob = '/api/applications/apply/';
  static const String applicationMessages = '/api/applications/{application_id}/messages/';

  static const String jobApplications = '/api/applications/job-applications/';
  static const String applicationDetail = '/api/applications/{id}/';
  static const String updateApplication = '/api/applications/{id}/update/';
  static const String withdrawApplication = '/api/applications/{application_id}/withdraw/';
  static const String markApplicationViewed = '/api/applications/{application_id}/mark-viewed/';
  static const String sendApplicationMessage = '/api/applications/{application_id}/messages/create/';
  static const String applicationStatistics = '/api/applications/statistics/';
  // interviews
  static const String interviews = '/api/applications/interviews/';
  static const String createInterview = '/api/applications/interviews/create/';
  static const String interviewDetail = '/api/applications/interviews/{id}/';

}

class AppEnums {
  // المدن
  static const Map<String, String> cities = {
    'sanaa': 'صنعاء',
    'aden': 'عدن',
    'taiz': 'تعز',
    'hodeidah': 'الحديدة',
    'ibb': 'إب',
    'dhamar': 'ذمار',
    'mukalla': 'المكلا',
    'remote': 'عمل عن بُعد',
  };

  // أنواع الوظائف
  static const Map<String, String> jobTypes = {
    'full_time': 'دوام كامل',
    'part_time': 'دوام جزئي',
    'contract': 'عقد مؤقت',
    'freelance': 'عمل حر',
    'internship': 'تدريب',
  };

  // مستويات الخبرة
  static const Map<String, String> experienceLevels = {
    'entry': 'مبتدئ (0-2 سنة)',
    'junior': 'مبتدئ متقدم (2-4 سنوات)',
    'mid': 'متوسط (4-7 سنوات)',
    'senior': 'خبير (7-10 سنوات)',
    'expert': 'خبير متقدم (10+ سنوات)',
  };

  // أحجام الشركات
  static const Map<String, String> companySizes = {
    'startup': 'ناشئة (1-10 موظفين)',
    'small': 'صغيرة (11-50 موظف)',
    'medium': 'متوسطة (51-200 موظف)',
    'large': 'كبيرة (201-1000 موظف)',
    'enterprise': 'مؤسسة (1000+ موظف)',
  };

  // القطاعات
  static const Map<String, String> industries = {
    'technology': 'تقنية المعلومات',
    'healthcare': 'الرعاية الصحية',
    'education': 'التعليم',
    'finance': 'المالية والمصرفية',
    'construction': 'البناء والتشييد',
    'retail': 'التجارة والبيع بالتجزئة',
    'manufacturing': 'التصنيع',
    'telecommunications': 'الاتصالات',
    'other': 'أخرى',
  };
}