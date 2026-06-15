// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for French (`fr`).
class AppLocalizationsFr extends AppLocalizations {
  AppLocalizationsFr([String locale = 'fr']) : super(locale);

  @override
  String get appTitle => 'NoshMesh';

  @override
  String get welcomeMessage => 'Bienvenue dans NoshMesh';

  @override
  String get home => 'Accueil';

  @override
  String get settings => 'Paramètres';

  @override
  String get profile => 'Profil';

  @override
  String get darkMode => 'Mode sombre';

  @override
  String get lightMode => 'Mode clair';

  @override
  String get systemMode => 'Mode système';

  @override
  String get language => 'Langue';

  @override
  String get change_language => 'Changer la langue de l\'application';

  @override
  String get theme => 'Thème';

  @override
  String get change_theme => 'Changer le thème de l\'application';

  @override
  String get notifications => 'Notifications';

  @override
  String get notification_settings =>
      'Configurer les préférences de notification';

  @override
  String get localization_demo => 'Démo de localisation';

  @override
  String get localization_demo_description =>
      'Voir les fonctionnalités de localisation en action';

  @override
  String get language_settings => 'Paramètres de langue';

  @override
  String get select_your_language => 'Sélectionnez votre langue préférée';

  @override
  String get language_explanation =>
      'La langue sélectionnée sera appliquée à l\'ensemble de l\'application';

  @override
  String get localization_assets_demo =>
      'Démo de localisation et de ressources';

  @override
  String get current_language => 'Langue actuelle';

  @override
  String get language_code => 'Code de langue';

  @override
  String get language_name => 'Nom de la langue';

  @override
  String get formatting_examples => 'Exemples de formatage';

  @override
  String get date_full => 'Date (complète)';

  @override
  String get date_short => 'Date (courte)';

  @override
  String get time => 'Heure';

  @override
  String get currency => 'Devise';

  @override
  String get percent => 'Pourcentage';

  @override
  String get localized_assets => 'Ressources localisées';

  @override
  String get localized_assets_explanation =>
      'Cette section montre comment charger différentes ressources en fonction de la langue sélectionnée. Les images, l\'audio et d\'autres ressources peuvent être spécifiques à une langue.';

  @override
  String get image_example => 'Exemple d\'image localisée';

  @override
  String get welcome_image_caption =>
      'Cette image est chargée en fonction de votre langue sélectionnée';

  @override
  String get common_image_example => 'Exemple d\'image commune';

  @override
  String get common_image_caption =>
      'Cette image est la même dans toutes les langues';

  @override
  String get logout => 'Déconnexion';

  @override
  String get login => 'Connexion';

  @override
  String get email => 'E-mail';

  @override
  String get password => 'Mot de passe';

  @override
  String get signIn => 'Se connecter';

  @override
  String get register => 'S\'inscrire';

  @override
  String get forgotPassword => 'Mot de passe oublié ?';

  @override
  String get errorOccurred => 'Une erreur est survenue';

  @override
  String get content_not_found => 'Contenu non trouvé';

  @override
  String get content_not_found_generic =>
      'Contenu non trouvé ou une erreur est survenue lors de la récupération.';

  @override
  String get tryAgain => 'Réessayer';

  @override
  String greeting(String name) {
    return 'Bonjour, $name !';
  }

  @override
  String itemCount(num count) {
    final intl.NumberFormat countNumberFormat = intl.NumberFormat.compact(
      locale: localeName,
    );
    final String countString = countNumberFormat.format(count);

    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$countString articles',
      one: '1 article',
      zero: 'Aucun article',
    );
    return '$_temp0';
  }

  @override
  String lastUpdated(DateTime date) {
    final intl.DateFormat dateDateFormat = intl.DateFormat.yMMMd(localeName);
    final String dateString = dateDateFormat.format(date);

    return 'Dernière mise à jour : $dateString';
  }

  @override
  String get content_published_successfully => 'Contenu publié avec succès';

  @override
  String get clear_all => 'Tout effacer';

  @override
  String get search_articles => 'Rechercher des articles...';

  @override
  String get enter_email => 'Entrez votre e-mail';

  @override
  String get enter_password => 'Entrez votre mot de passe';

  @override
  String get no_matching_articles_found =>
      'Aucun article correspondant trouvé.';

  @override
  String get selected => 'Sélectionné';

  @override
  String get select => 'Sélectionner';

  @override
  String get filter_by_source => 'Filtrer par source';

  @override
  String get clear_all_filters => 'Effacer tous les filtres';

  @override
  String get select_all => 'Tout sélectionner';

  @override
  String get unselect_all => 'Tout désélectionner';

  @override
  String get merge => 'Fusionner';

  @override
  String get external_endpoints => 'Points de terminaison externes';

  @override
  String get manage_endpoints => 'Gérer vos plateformes intégrées';

  @override
  String get change_password => 'Changer le mot de passe';

  @override
  String get current_password => 'Mot de passe actuel';

  @override
  String get new_password => 'Nouveau mot de passe';

  @override
  String get confirm_new_password => 'Confirmer le nouveau mot de passe';

  @override
  String get save_changes => 'Enregistrer les modifications';

  @override
  String get profile_updated => 'Profil mis à jour avec succès';

  @override
  String get update_profile_failed => 'Échec de la mise à jour du profil';

  @override
  String get name => 'Nom';

  @override
  String get name_required => 'Le nom est requis';

  @override
  String get email_required => 'L\'e-mail est requis';

  @override
  String get invalid_email => 'E-mail invalide';

  @override
  String get required => 'Requis';

  @override
  String get send_reset_link => 'Send Reset Link';

  @override
  String get reset_password_instruction =>
      'Enter your email to receive a password reset link.';

  @override
  String get reset_your_password => 'Reset Your Password';

  @override
  String get back_to_login => 'Retour à la connexion';

  @override
  String get reset_password => 'Réinitialiser le mot de passe';

  @override
  String get reset_token => 'Jeton de réinitialisation';

  @override
  String get reset_token_hint => 'Collez le jeton de votre e-mail';

  @override
  String get enter_reset_token =>
      'Veuillez entrer le jeton de réinitialisation';

  @override
  String get password_reset_success => 'Mot de passe réinitialisé avec succès';

  @override
  String get failed_to_reset_password =>
      'Échec de la réinitialisation du mot de passe';

  @override
  String get verify_email => 'Vérifier l\'e-mail';

  @override
  String get check_your_email => 'Vérifiez votre e-mail';

  @override
  String get verification_code_sent =>
      'Nous avons envoyé un code de vérification à votre e-mail';

  @override
  String get verification_code => 'Code de vérification';

  @override
  String get enter_6_digit_code => 'Entrez le code à 6 chiffres';

  @override
  String get enter_verification_code =>
      'Veuillez entrer le code de vérification';

  @override
  String get code_must_be_6_digits => 'Le code doit comporter 6 chiffres';

  @override
  String get verify => 'Vérifier';

  @override
  String get resend_code => 'Renvoyer le code';

  @override
  String get reset_link_sent =>
      'Si un compte avec cet e-mail existe, un lien de réinitialisation du mot de passe a été envoyé.';

  @override
  String get passwords_dont_match => 'Les mots de passe ne correspondent pas';

  @override
  String get update_your_security => 'Mettez à jour votre sécurité';

  @override
  String get ensure_account_secure =>
      'Assurez-vous que votre compte reste sécurisé en utilisant un mot de passe fort.';

  @override
  String get password_changed_success => 'Mot de passe changé avec succès';

  @override
  String get password_changed_error => 'Échec du changement de mot de passe';

  @override
  String get ai_text_generation => 'Génération de texte par IA';

  @override
  String get quota_exceeded_web_upgrade =>
      'Quota dépassé. Veuillez visiter notre site web pour mettre à jour votre forfait et continuer.';

  @override
  String get monthly_limit_reached_web_upgrade =>
      'Limite mensuelle atteinte. Veuillez visiter notre site web pour mettre à jour votre forfait.';

  @override
  String get enter_your_prompt => 'Entrez votre invite';

  @override
  String get generate => 'Générer';

  @override
  String get validate_and_merge => 'Valider et fusionner';

  @override
  String get no_articles_to_validate => 'Aucun article à valider.';

  @override
  String get previous => 'Précédent';

  @override
  String get please_enter_title => 'Veuillez entrer un titre.';

  @override
  String get articles_merged_successfully =>
      'Articles fusionnés avec succès ! Redirection vers l\'édition.';

  @override
  String get merge_articles => 'Fusionner les articles';

  @override
  String get cancel => 'Annuler';

  @override
  String validate_article(Object current, Object total) {
    return 'Valider l\'article $current sur $total';
  }

  @override
  String get captcha_instruction =>
      'J\'ai terminé la connexion/le captcha sur la page';

  @override
  String get quota_reached_web =>
      'Quota atteint. Veuillez visiter notre site web pour mettre à jour.';

  @override
  String get title_merged_article => 'Titre de l\'article fusionné';

  @override
  String failed_to_merge(Object error) {
    return 'Échec de la fusion des articles : $error';
  }

  @override
  String get next => 'Suivant';

  @override
  String get title => 'Titre';

  @override
  String get error => 'Erreur';

  @override
  String get loading_content => 'Chargement du contenu...';

  @override
  String get edit_merged_content => 'Modifier le contenu fusionné';

  @override
  String get body => 'Corps';

  @override
  String get please_enter_content => 'Veuillez entrer du contenu.';

  @override
  String get no_articles_found => 'Aucun article trouvé.';

  @override
  String get fetching_all_feeds => 'Récupération de tous les flux...';

  @override
  String get all => 'Tout';

  @override
  String get draft => 'Brouillon';

  @override
  String get published => 'Publié';

  @override
  String get no_merged_contents => 'Aucun contenu fusionné trouvé.';

  @override
  String status_label(Object status) {
    return 'Statut : $status';
  }

  @override
  String get no_rss_feeds => 'Aucun flux RSS trouvé.';

  @override
  String get delete_rss_feed => 'Supprimer le flux RSS';

  @override
  String get delete_feed_confirmation =>
      'Êtes-vous sûr de vouloir supprimer ce flux ?';

  @override
  String get delete => 'Supprimer';

  @override
  String get publish_options => 'Options de publication';

  @override
  String get status => 'Statut';

  @override
  String get external_endpoint => 'Point de terminaison externe';

  @override
  String get none => 'Aucun';

  @override
  String get publish => 'Publier';

  @override
  String get update_rss_feed => 'Mettre à jour le flux RSS';

  @override
  String get add_rss_feed => 'Ajouter un flux RSS';

  @override
  String get feed_url => 'URL du flux';

  @override
  String get enter_url => 'Veuillez entrer une URL valide';

  @override
  String get auto_generate_name => 'Générer le nom automatiquement';

  @override
  String get save => 'Enregistrer';

  @override
  String get add => 'Ajouter';

  @override
  String get no_external_endpoints =>
      'Aucun point de terminaison externe trouvé.';

  @override
  String get delete_endpoint => 'Supprimer le point de terminaison';

  @override
  String delete_endpoint_confirmation(Object name) {
    return 'Êtes-vous sûr de vouloir supprimer $name ?';
  }

  @override
  String get endpoint_deleted_successfully =>
      'Point de terminaison supprimé avec succès !';

  @override
  String get external_endpoint_updated =>
      'Point de terminaison externe mis à jour avec succès !';

  @override
  String get external_endpoint_created =>
      'Point de terminaison externe créé avec succès !';

  @override
  String get edit_endpoint => 'Modifier le point de terminaison';

  @override
  String get create_new_endpoint => 'Créer un nouveau point de terminaison';

  @override
  String get platform_name => 'Nom de la plateforme';

  @override
  String get api_url => 'URL de l\'API';

  @override
  String get auth_token_label => 'Jeton d\'authentification (clé API)';

  @override
  String get update_endpoint => 'Mettre à jour le point de terminaison';

  @override
  String get create_endpoint => 'Créer le point de terminaison';

  @override
  String failed_to_save_options(Object error) {
    return 'Échec de l\'enregistrement des options : $error';
  }

  @override
  String failed_to_publish(Object error) {
    return 'Échec de la publication : $error';
  }

  @override
  String get page_not_found => 'Page non trouvée';

  @override
  String page_path_not_found(Object path) {
    return 'La page $path n\'a pas été trouvée';
  }

  @override
  String get go_home => 'Aller à l\'accueil';

  @override
  String get live_chat => 'Support en direct';

  @override
  String get online => 'En ligne';

  @override
  String get offline => 'Hors ligne';

  @override
  String get no_messages =>
      'Aucun message pour l\'instant. Envoyez un message pour commencer à discuter !';

  @override
  String get type_message => 'Tapez un message...';

  @override
  String get quota_reached => 'Quota atteint';

  @override
  String get quota_reached_upgrade =>
      'Quota atteint. Veuillez visiter notre site web pour mettre à jour.';

  @override
  String get monthly_limit_reached => 'Limite mensuelle atteinte';

  @override
  String get quota_reached_explanation =>
      'Vous avez atteint votre quota mensuel de jetons. Veuillez visiter notre site web pour mettre à jour votre forfait et continuer à utiliser les fonctionnalités d\'IA.';

  @override
  String get enjoying_app => 'Vous appréciez l\'application ?';

  @override
  String get no_thanks => 'Non merci';

  @override
  String get sure => 'Bien sûr !';

  @override
  String get whats_new => 'Quoi de neuf :';

  @override
  String get later => 'Plus tard';

  @override
  String get view_plans => 'Voir les forfaits';

  @override
  String get close => 'Fermer';

  @override
  String get share_feedback_question =>
      'Souhaitez-vous nous faire part de vos commentaires ?';

  @override
  String get feedback_matters => 'Votre avis compte';

  @override
  String get share_thoughts =>
      'N\'hésitez pas à nous faire part de vos réflexions sur l\'application. Si vous l\'appréciez, un avis sur l\'app store serait grandement apprécié !';

  @override
  String get feedback_hint => 'Entrez vos commentaires ici';

  @override
  String get submit => 'Soumettre';

  @override
  String get required_update => 'Mise à jour requise';

  @override
  String get update_available => 'Mise à jour disponible';

  @override
  String critical_update_message(Object version) {
    return 'Une mise à jour critique (version $version) est requise pour continuer à utiliser cette application.';
  }

  @override
  String new_version_available(Object version) {
    return 'Une nouvelle version ($version) est disponible.';
  }

  @override
  String get update_now => 'Mettre à jour maintenant';

  @override
  String get update => 'Mettre à jour';
}
