// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Spanish Castilian (`es`).
class AppLocalizationsEs extends AppLocalizations {
  AppLocalizationsEs([String locale = 'es']) : super(locale);

  @override
  String get settings => 'Configuración';

  @override
  String get language => 'Idioma';

  @override
  String get english => 'Inglés';

  @override
  String get spanish => 'Español';

  @override
  String get select_language => 'Seleccionar Idioma';

  @override
  String get default_ride => 'Viaje Predeterminado';

  @override
  String get delete_account => 'Eliminar Cuenta';

  @override
  String get logout => 'Cerrar sesión';

  @override
  String get cancel => 'Cancelar';

  @override
  String get delete => 'Eliminar';

  @override
  String get delete_account_confirm =>
      '¿Estás seguro de que quieres eliminar tu cuenta? Esta acción no se puede deshacer y perderás todos tus datos.';

  @override
  String get logout_confirm =>
      '¿Estás seguro de que quieres cerrar sesión? Tendrás que iniciar sesión de nuevo para acceder a tu cuenta.';

  @override
  String get profile => 'Perfil';

  @override
  String get total_rides => 'Total de Viajes';

  @override
  String get total_spent => 'Total Gastado';

  @override
  String get frequent_location => 'Ubicación Frecuente';

  @override
  String get avg_ride_time => 'Tiempo Promedio de Viaje';

  @override
  String get linked_accounts => 'Cuentas Vinculadas';

  @override
  String get help_center => 'Centro de Ayuda';

  @override
  String get privacy_policy => 'Política de Privacidad';

  @override
  String get report => 'Reportar';

  @override
  String get about_us => 'Sobre Nosotros';

  @override
  String get log_out => 'Cerrar sesión';

  @override
  String get connected => 'Conectado';

  @override
  String get disconnect => 'Desconectar';

  @override
  String get link => 'Vincular';

  @override
  String get link_platform => 'Vincular Plataforma';

  @override
  String get search_country => 'Buscar país';

  @override
  String get phone => 'Teléfono';

  @override
  String get drivers_license_number => 'Número de licencia de conducir';

  @override
  String get continue_btn => 'Continuar';

  @override
  String get enter_verification_code => 'Ingrese el código de verificación';

  @override
  String get verify => 'Verificar';

  @override
  String get didnt_receive_code => '¿No recibiste el código? ';

  @override
  String get resend => 'Reenviar';

  @override
  String get security_footer =>
      'Solo leemos datos de ganancias. Nunca modificamos tu cuenta.';

  @override
  String get syncing => 'Sincronizando';

  @override
  String get pulling_ride_history => 'Obteniendo tu historial de viajes...';

  @override
  String connecting_to(String platform) {
    return 'Conectando a $platform...';
  }

  @override
  String platform_connected(String platform) {
    return '$platform Conectado';
  }

  @override
  String get found_trips => '142 viajes encontrados';

  @override
  String get estimated_sync_time =>
      'Tiempo de sincronización estimado: 1 minuto';

  @override
  String get securely_syncing =>
      'Sincronizando tus datos de viaje de forma segura.';

  @override
  String get trips_synced =>
      'Tus viajes ahora están sincronizados con\nRYDE-IQ.';

  @override
  String get done => 'Hecho';

  @override
  String get login => 'Iniciar sesión';

  @override
  String get create_account => 'Crear Cuenta';

  @override
  String get send_otp => 'Enviar código OTP';

  @override
  String get otp_sent => 'Código OTP enviado';

  @override
  String get enter_otp => 'Ingresar código OTP';

  @override
  String get resend_otp_in => 'Reenviar código OTP en ';

  @override
  String get error => 'Error';

  @override
  String get verification_code_msg =>
      'Enviaremos un código de verificación a tu número.';

  @override
  String get first_name => 'Nombre';

  @override
  String get last_name => 'Apellido';

  @override
  String get email_optional => 'Correo electrónico (Opcional)';

  @override
  String get confirm => 'Confirmar';

  @override
  String get by_clicking_confirm => 'Al hacer clic en Confirmar, acepto los\n';

  @override
  String get terms_and_conditions => 'Términos y Condiciones';

  @override
  String get and_text => ' y ';

  @override
  String get what_brings_you_here => '¿Qué te trae por aquí?';

  @override
  String get im_a_passenger => 'Soy un pasajero';

  @override
  String get find_cheapest_ride_fares => 'Encuentra tarifas más baratas';

  @override
  String get im_a_driver => 'Soy un conductor';

  @override
  String get compare_my_earnings => 'Compara mis ganancias';

  @override
  String get allow_permissions => 'Permitir permisos';

  @override
  String get location => 'Ubicación';

  @override
  String get location_subtitle =>
      'Se usa para detectar tu ubicación de recogida';

  @override
  String get notifications => 'Notificaciones';

  @override
  String get notifications_subtitle =>
      'Se usa para alertas de tarifas e información del conductor';

  @override
  String get welcome_title => 'Convierte cada viaje\nen información.';

  @override
  String get welcome_login => 'Iniciar sesión';

  @override
  String get welcome_signup => 'Regístrate';

  @override
  String get paywall_billed_after_trial =>
      'Después de la prueba GRATUITA, se le facturará...';

  @override
  String get paywall_monthly => 'Mensual';

  @override
  String get paywall_yearly => 'Anual';

  @override
  String get paywall_save_percent => 'Ahorra 30%';

  @override
  String get paywall_month => ' /Mes';

  @override
  String get paywall_year => ' /Año';

  @override
  String get paywall_benefits => 'Beneficios';

  @override
  String get paywall_benefit_1 => '1. Compara precios de viajes al instante';

  @override
  String get paywall_benefit_2 => '2. Haz un seguimiento de tus ganancias';

  @override
  String get paywall_benefit_3 =>
      '3. Obtén información para maximizar ingresos';

  @override
  String get paywall_start_trial => 'Iniciar prueba gratuita';

  @override
  String get paywall_title => 'Empieza a ahorrar más\nen cada viaje';

  @override
  String get paywall_subtitle =>
      'Compara tarifas y haz un seguimiento de tus ganancias en un solo lugar.';

  @override
  String get paywall_7_day_trial => 'Prueba gratuita de 7 días';

  @override
  String get paywall_no_charges => 'Sin cargos hoy. Cancela cuando quieras.';

  @override
  String get rider => 'Pasajero';

  @override
  String get driver => 'Conductor';

  @override
  String version_info(String version) {
    return 'Versión $version';
  }

  @override
  String get notifications_title => 'Notificaciones';

  @override
  String get clear => 'Limpiar';

  @override
  String get no_notifications_yet => 'Aún no hay notificaciones';

  @override
  String get search_location => 'Buscar ubicación';

  @override
  String get current_location => 'Ubicación actual';

  @override
  String opening_platform(String platform) {
    return 'Abriendo $platform';
  }

  @override
  String get locations_added =>
      'Se han añadido tus ubicaciones\nde recogida y destino.';

  @override
  String get app_not_installed_title => 'La aplicación no está instalada';

  @override
  String get_app_to_book(String platform) {
    return 'Consigue $platform para reservar el viaje seleccionado.';
  }

  @override
  String install_platform(String platform) {
    return 'Instalar $platform';
  }

  @override
  String get app_not_installed_question => '¿Aplicación no instalada?';

  @override
  String get driver_dashboard_title => 'Panel de conductor';

  @override
  String get driver_dashboard_subtitle =>
      'Mira lo que realmente estás ganando.';

  @override
  String get tab_today => 'Hoy';

  @override
  String get tab_weekly => 'Semanal';

  @override
  String get tab_all_time => 'Todo el tiempo';

  @override
  String get todays_earnings => 'Ganancias de hoy';

  @override
  String quick_stats_platform(String platform) {
    return 'Estadísticas de $platform';
  }

  @override
  String get trips_today => 'Viajes hoy';

  @override
  String get online_hours => 'Horas en línea';

  @override
  String get miles_driven => 'Millas conducidas';

  @override
  String get tips_earned => 'Propinas ganadas';

  @override
  String get idle_time => 'Tiempo inactivo';

  @override
  String get acceptance_rate => 'Tasa de aceptación';

  @override
  String get insight_today_uber =>
      'Hoy ganaste más por hora en Uber que en las otras plataformas.';

  @override
  String get insight_weekly_uber =>
      'Esta semana ganaste más por hora en Uber que en las otras plataformas.';

  @override
  String get earnings_by_day => 'Ganancias por día';

  @override
  String quick_stats_for_platform(String platform) {
    return 'Estadísticas de $platform';
  }

  @override
  String get total_earnings => 'Ganancias totales';

  @override
  String get earnings_per_hour => 'Ganancias por hora';

  @override
  String get total_trips => 'Viajes totales';

  @override
  String get total_hours => 'Horas totales';

  @override
  String get platform_earnings_comparison =>
      'Comparación de ganancias por plataforma';

  @override
  String get best_platform => 'Mejor plataforma';

  @override
  String per_hour(String amount) {
    return '$amount por hora';
  }

  @override
  String get milestones => 'Hitos';

  @override
  String get milestone_completed => 'Completado';

  @override
  String get milestone_in_progress => 'En progreso';

  @override
  String get milestone_locked => 'Bloqueado';

  @override
  String get trips => 'Viajes';

  @override
  String get milestone_earned => 'Ganado';

  @override
  String get quick_stats => 'Estadísticas';

  @override
  String get avg_rating => 'Calificación prom.';

  @override
  String get go_to_dashboard => 'Ir al panel de control';

  @override
  String get not_linked => 'No vinculado';
}
