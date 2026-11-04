// GENERATED CODE - DO NOT MODIFY BY HAND
// dart format width=80

// **************************************************************************
// InjectableConfigGenerator
// **************************************************************************

// ignore_for_file: type=lint
// coverage:ignore-file

// ignore_for_file: no_leading_underscores_for_library_prefixes

import 'package:cookie_jar/cookie_jar.dart' as _i557;
import 'package:dio/dio.dart' as _i361;
import 'package:dut_curriculum_app/core/di/localization_module.dart' as _i489;
import 'package:dut_curriculum_app/core/files/attachment_viewer.dart' as _i505;
import 'package:dut_curriculum_app/core/network/csrf_interceptor.dart' as _i983;
import 'package:dut_curriculum_app/core/network/dio_module.dart' as _i989;
import 'package:dut_curriculum_app/core/network/session_expiry_interceptor.dart'
    as _i940;
import 'package:dut_curriculum_app/core/session/session_events.dart' as _i1009;
import 'package:dut_curriculum_app/features/auth/data/auth_repository_impl.dart'
    as _i32;
import 'package:dut_curriculum_app/features/auth/data/remote/auth_api.dart'
    as _i108;
import 'package:dut_curriculum_app/features/auth/domain/repository/auth_repository.dart'
    as _i146;
import 'package:dut_curriculum_app/features/auth/domain/use_case/auth_use_cases.dart'
    as _i187;
import 'package:dut_curriculum_app/features/auth/presentation/change_password/change_password_cubit.dart'
    as _i403;
import 'package:dut_curriculum_app/features/auth/presentation/login/login_cubit.dart'
    as _i511;
import 'package:dut_curriculum_app/features/auth/presentation/session/session_cubit.dart'
    as _i466;
import 'package:dut_curriculum_app/features/portal/data/portal_repository_impl.dart'
    as _i945;
import 'package:dut_curriculum_app/features/portal/data/remote/attachment_cache.dart'
    as _i640;
import 'package:dut_curriculum_app/features/portal/data/remote/portal_api.dart'
    as _i689;
import 'package:dut_curriculum_app/features/portal/domain/model/portal_context.dart'
    as _i672;
import 'package:dut_curriculum_app/features/portal/domain/repository/portal_repository.dart'
    as _i281;
import 'package:dut_curriculum_app/features/portal/domain/use_case/portal_use_cases.dart'
    as _i369;
import 'package:dut_curriculum_app/features/portal/presentation/context/portal_context_cubit.dart'
    as _i864;
import 'package:dut_curriculum_app/features/portal/presentation/curriculum/curriculum_cubit.dart'
    as _i827;
import 'package:dut_curriculum_app/features/portal/presentation/graduation/graduation_cubit.dart'
    as _i377;
import 'package:dut_curriculum_app/features/portal/presentation/plos/plos_cubit.dart'
    as _i627;
import 'package:dut_curriculum_app/features/portal/presentation/progress/progress_cubit.dart'
    as _i450;
import 'package:dut_curriculum_app/features/portal/presentation/registration/registration_cubit.dart'
    as _i712;
import 'package:dut_curriculum_app/features/portal/presentation/syllabus/syllabus_cubit.dart'
    as _i400;
import 'package:dut_curriculum_app/l10n/app_localizations.dart' as _i703;
import 'package:get_it/get_it.dart' as _i174;
import 'package:injectable/injectable.dart' as _i526;

extension GetItInjectableX on _i174.GetIt {
  // initializes the registration of main-scope dependencies inside of GetIt
  Future<_i174.GetIt> init({
    String? environment,
    _i526.EnvironmentFilter? environmentFilter,
  }) async {
    final gh = _i526.GetItHelper(this, environment, environmentFilter);
    final localizationModule = _$LocalizationModule();
    final networkModule = _$NetworkModule();
    gh.factory<_i983.CsrfInterceptor>(() => _i983.CsrfInterceptor());
    gh.singleton<_i703.AppLocalizations>(
      () => localizationModule.localizations,
    );
    gh.singleton<_i505.AttachmentViewer>(() => _i505.AttachmentViewer());
    await gh.singletonAsync<_i557.PersistCookieJar>(
      () => networkModule.cookieJar(),
      preResolve: true,
    );
    gh.singleton<_i1009.SessionEvents>(
      () => _i1009.SessionEvents(),
      dispose: (i) => i.dispose(),
    );
    gh.singleton<_i640.AttachmentCache>(() => _i640.AttachmentCache());
    gh.factory<_i940.SessionExpiryInterceptor>(
      () => _i940.SessionExpiryInterceptor(gh<_i1009.SessionEvents>()),
    );
    gh.singleton<_i361.Dio>(
      () => networkModule.dio(
        gh<_i557.PersistCookieJar>(),
        gh<_i983.CsrfInterceptor>(),
        gh<_i940.SessionExpiryInterceptor>(),
      ),
    );
    gh.singleton<_i108.AuthApi>(
      () => _i108.AuthApi(gh<_i361.Dio>(), gh<_i703.AppLocalizations>()),
    );
    gh.singleton<_i689.PortalApi>(
      () => _i689.PortalApi(
        gh<_i361.Dio>(),
        gh<_i703.AppLocalizations>(),
        gh<_i640.AttachmentCache>(),
      ),
    );
    gh.singleton<_i146.AuthRepository>(
      () => _i32.AuthRepositoryImpl(
        gh<_i108.AuthApi>(),
        gh<_i557.PersistCookieJar>(),
      ),
    );
    gh.singleton<_i281.PortalRepository>(
      () => _i945.PortalRepositoryImpl(gh<_i689.PortalApi>()),
    );
    gh.factory<_i187.AuthUseCases>(
      () => _i187.AuthUseCases(gh<_i146.AuthRepository>()),
    );
    gh.factory<_i403.ChangePasswordCubit>(
      () => _i403.ChangePasswordCubit(
        gh<_i187.AuthUseCases>(),
        gh<_i703.AppLocalizations>(),
      ),
    );
    gh.factory<_i511.LoginCubit>(
      () => _i511.LoginCubit(
        gh<_i187.AuthUseCases>(),
        gh<_i703.AppLocalizations>(),
      ),
    );
    gh.factory<_i369.PortalUseCases>(
      () => _i369.PortalUseCases(gh<_i281.PortalRepository>()),
    );
    gh.singleton<_i466.SessionCubit>(
      () => _i466.SessionCubit(
        gh<_i187.AuthUseCases>(),
        gh<_i1009.SessionEvents>(),
      ),
      dispose: (i) => i.close(),
    );
    gh.factoryParam<_i827.CurriculumCubit, _i672.PortalContext, dynamic>(
      (context, _) =>
          _i827.CurriculumCubit(gh<_i369.PortalUseCases>(), context),
    );
    gh.factoryParam<_i377.GraduationCubit, _i672.PortalContext, dynamic>(
      (context, _) =>
          _i377.GraduationCubit(gh<_i369.PortalUseCases>(), context),
    );
    gh.factoryParam<_i627.PlosCubit, _i672.PortalContext, dynamic>(
      (context, _) => _i627.PlosCubit(gh<_i369.PortalUseCases>(), context),
    );
    gh.factoryParam<_i450.ProgressCubit, _i672.PortalContext, dynamic>(
      (context, _) => _i450.ProgressCubit(gh<_i369.PortalUseCases>(), context),
    );
    gh.factoryParam<_i712.RegistrationCubit, _i672.PortalContext, dynamic>(
      (context, _) =>
          _i712.RegistrationCubit(gh<_i369.PortalUseCases>(), context),
    );
    gh.factoryParam<_i400.SyllabusCubit, _i672.PortalContext, String>(
      (context, itemId) => _i400.SyllabusCubit(
        gh<_i369.PortalUseCases>(),
        gh<_i505.AttachmentViewer>(),
        context,
        itemId,
      ),
    );
    gh.factory<_i864.PortalContextCubit>(
      () => _i864.PortalContextCubit(gh<_i369.PortalUseCases>()),
    );
    return this;
  }
}

class _$LocalizationModule extends _i489.LocalizationModule {}

class _$NetworkModule extends _i989.NetworkModule {}
