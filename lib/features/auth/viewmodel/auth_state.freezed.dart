// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'auth_state.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$AuthState {

 String get countryCode; String get phoneNumber; String get otp; bool get isOtpSent; int get resendTimer; int get resendAttempt; bool get isLoading; bool get isOtpLoading; bool get isLoginLoading; String? get errorMessage; String? get verificationId; int? get resendToken; String get firstName; String get lastName; String get email; String get userType; bool get locationGranted; bool get notificationsGranted; bool get isAuthenticated;
/// Create a copy of AuthState
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$AuthStateCopyWith<AuthState> get copyWith => _$AuthStateCopyWithImpl<AuthState>(this as AuthState, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is AuthState&&(identical(other.countryCode, countryCode) || other.countryCode == countryCode)&&(identical(other.phoneNumber, phoneNumber) || other.phoneNumber == phoneNumber)&&(identical(other.otp, otp) || other.otp == otp)&&(identical(other.isOtpSent, isOtpSent) || other.isOtpSent == isOtpSent)&&(identical(other.resendTimer, resendTimer) || other.resendTimer == resendTimer)&&(identical(other.resendAttempt, resendAttempt) || other.resendAttempt == resendAttempt)&&(identical(other.isLoading, isLoading) || other.isLoading == isLoading)&&(identical(other.isOtpLoading, isOtpLoading) || other.isOtpLoading == isOtpLoading)&&(identical(other.isLoginLoading, isLoginLoading) || other.isLoginLoading == isLoginLoading)&&(identical(other.errorMessage, errorMessage) || other.errorMessage == errorMessage)&&(identical(other.verificationId, verificationId) || other.verificationId == verificationId)&&(identical(other.resendToken, resendToken) || other.resendToken == resendToken)&&(identical(other.firstName, firstName) || other.firstName == firstName)&&(identical(other.lastName, lastName) || other.lastName == lastName)&&(identical(other.email, email) || other.email == email)&&(identical(other.userType, userType) || other.userType == userType)&&(identical(other.locationGranted, locationGranted) || other.locationGranted == locationGranted)&&(identical(other.notificationsGranted, notificationsGranted) || other.notificationsGranted == notificationsGranted)&&(identical(other.isAuthenticated, isAuthenticated) || other.isAuthenticated == isAuthenticated));
}


@override
int get hashCode => Object.hashAll([runtimeType,countryCode,phoneNumber,otp,isOtpSent,resendTimer,resendAttempt,isLoading,isOtpLoading,isLoginLoading,errorMessage,verificationId,resendToken,firstName,lastName,email,userType,locationGranted,notificationsGranted,isAuthenticated]);

@override
String toString() {
  return 'AuthState(countryCode: $countryCode, phoneNumber: $phoneNumber, otp: $otp, isOtpSent: $isOtpSent, resendTimer: $resendTimer, resendAttempt: $resendAttempt, isLoading: $isLoading, isOtpLoading: $isOtpLoading, isLoginLoading: $isLoginLoading, errorMessage: $errorMessage, verificationId: $verificationId, resendToken: $resendToken, firstName: $firstName, lastName: $lastName, email: $email, userType: $userType, locationGranted: $locationGranted, notificationsGranted: $notificationsGranted, isAuthenticated: $isAuthenticated)';
}


}

/// @nodoc
abstract mixin class $AuthStateCopyWith<$Res>  {
  factory $AuthStateCopyWith(AuthState value, $Res Function(AuthState) _then) = _$AuthStateCopyWithImpl;
@useResult
$Res call({
 String countryCode, String phoneNumber, String otp, bool isOtpSent, int resendTimer, int resendAttempt, bool isLoading, bool isOtpLoading, bool isLoginLoading, String? errorMessage, String? verificationId, int? resendToken, String firstName, String lastName, String email, String userType, bool locationGranted, bool notificationsGranted, bool isAuthenticated
});




}
/// @nodoc
class _$AuthStateCopyWithImpl<$Res>
    implements $AuthStateCopyWith<$Res> {
  _$AuthStateCopyWithImpl(this._self, this._then);

  final AuthState _self;
  final $Res Function(AuthState) _then;

/// Create a copy of AuthState
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? countryCode = null,Object? phoneNumber = null,Object? otp = null,Object? isOtpSent = null,Object? resendTimer = null,Object? resendAttempt = null,Object? isLoading = null,Object? isOtpLoading = null,Object? isLoginLoading = null,Object? errorMessage = freezed,Object? verificationId = freezed,Object? resendToken = freezed,Object? firstName = null,Object? lastName = null,Object? email = null,Object? userType = null,Object? locationGranted = null,Object? notificationsGranted = null,Object? isAuthenticated = null,}) {
  return _then(_self.copyWith(
countryCode: null == countryCode ? _self.countryCode : countryCode // ignore: cast_nullable_to_non_nullable
as String,phoneNumber: null == phoneNumber ? _self.phoneNumber : phoneNumber // ignore: cast_nullable_to_non_nullable
as String,otp: null == otp ? _self.otp : otp // ignore: cast_nullable_to_non_nullable
as String,isOtpSent: null == isOtpSent ? _self.isOtpSent : isOtpSent // ignore: cast_nullable_to_non_nullable
as bool,resendTimer: null == resendTimer ? _self.resendTimer : resendTimer // ignore: cast_nullable_to_non_nullable
as int,resendAttempt: null == resendAttempt ? _self.resendAttempt : resendAttempt // ignore: cast_nullable_to_non_nullable
as int,isLoading: null == isLoading ? _self.isLoading : isLoading // ignore: cast_nullable_to_non_nullable
as bool,isOtpLoading: null == isOtpLoading ? _self.isOtpLoading : isOtpLoading // ignore: cast_nullable_to_non_nullable
as bool,isLoginLoading: null == isLoginLoading ? _self.isLoginLoading : isLoginLoading // ignore: cast_nullable_to_non_nullable
as bool,errorMessage: freezed == errorMessage ? _self.errorMessage : errorMessage // ignore: cast_nullable_to_non_nullable
as String?,verificationId: freezed == verificationId ? _self.verificationId : verificationId // ignore: cast_nullable_to_non_nullable
as String?,resendToken: freezed == resendToken ? _self.resendToken : resendToken // ignore: cast_nullable_to_non_nullable
as int?,firstName: null == firstName ? _self.firstName : firstName // ignore: cast_nullable_to_non_nullable
as String,lastName: null == lastName ? _self.lastName : lastName // ignore: cast_nullable_to_non_nullable
as String,email: null == email ? _self.email : email // ignore: cast_nullable_to_non_nullable
as String,userType: null == userType ? _self.userType : userType // ignore: cast_nullable_to_non_nullable
as String,locationGranted: null == locationGranted ? _self.locationGranted : locationGranted // ignore: cast_nullable_to_non_nullable
as bool,notificationsGranted: null == notificationsGranted ? _self.notificationsGranted : notificationsGranted // ignore: cast_nullable_to_non_nullable
as bool,isAuthenticated: null == isAuthenticated ? _self.isAuthenticated : isAuthenticated // ignore: cast_nullable_to_non_nullable
as bool,
  ));
}

}


/// Adds pattern-matching-related methods to [AuthState].
extension AuthStatePatterns on AuthState {
/// A variant of `map` that fallback to returning `orElse`.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case _:
///     return orElse();
/// }
/// ```

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _AuthState value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _AuthState() when $default != null:
return $default(_that);case _:
  return orElse();

}
}
/// A `switch`-like method, using callbacks.
///
/// Callbacks receives the raw object, upcasted.
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case final Subclass2 value:
///     return ...;
/// }
/// ```

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _AuthState value)  $default,){
final _that = this;
switch (_that) {
case _AuthState():
return $default(_that);case _:
  throw StateError('Unexpected subclass');

}
}
/// A variant of `map` that fallback to returning `null`.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case _:
///     return null;
/// }
/// ```

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _AuthState value)?  $default,){
final _that = this;
switch (_that) {
case _AuthState() when $default != null:
return $default(_that);case _:
  return null;

}
}
/// A variant of `when` that fallback to an `orElse` callback.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case _:
///     return orElse();
/// }
/// ```

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String countryCode,  String phoneNumber,  String otp,  bool isOtpSent,  int resendTimer,  int resendAttempt,  bool isLoading,  bool isOtpLoading,  bool isLoginLoading,  String? errorMessage,  String? verificationId,  int? resendToken,  String firstName,  String lastName,  String email,  String userType,  bool locationGranted,  bool notificationsGranted,  bool isAuthenticated)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _AuthState() when $default != null:
return $default(_that.countryCode,_that.phoneNumber,_that.otp,_that.isOtpSent,_that.resendTimer,_that.resendAttempt,_that.isLoading,_that.isOtpLoading,_that.isLoginLoading,_that.errorMessage,_that.verificationId,_that.resendToken,_that.firstName,_that.lastName,_that.email,_that.userType,_that.locationGranted,_that.notificationsGranted,_that.isAuthenticated);case _:
  return orElse();

}
}
/// A `switch`-like method, using callbacks.
///
/// As opposed to `map`, this offers destructuring.
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case Subclass2(:final field2):
///     return ...;
/// }
/// ```

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String countryCode,  String phoneNumber,  String otp,  bool isOtpSent,  int resendTimer,  int resendAttempt,  bool isLoading,  bool isOtpLoading,  bool isLoginLoading,  String? errorMessage,  String? verificationId,  int? resendToken,  String firstName,  String lastName,  String email,  String userType,  bool locationGranted,  bool notificationsGranted,  bool isAuthenticated)  $default,) {final _that = this;
switch (_that) {
case _AuthState():
return $default(_that.countryCode,_that.phoneNumber,_that.otp,_that.isOtpSent,_that.resendTimer,_that.resendAttempt,_that.isLoading,_that.isOtpLoading,_that.isLoginLoading,_that.errorMessage,_that.verificationId,_that.resendToken,_that.firstName,_that.lastName,_that.email,_that.userType,_that.locationGranted,_that.notificationsGranted,_that.isAuthenticated);case _:
  throw StateError('Unexpected subclass');

}
}
/// A variant of `when` that fallback to returning `null`
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case _:
///     return null;
/// }
/// ```

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String countryCode,  String phoneNumber,  String otp,  bool isOtpSent,  int resendTimer,  int resendAttempt,  bool isLoading,  bool isOtpLoading,  bool isLoginLoading,  String? errorMessage,  String? verificationId,  int? resendToken,  String firstName,  String lastName,  String email,  String userType,  bool locationGranted,  bool notificationsGranted,  bool isAuthenticated)?  $default,) {final _that = this;
switch (_that) {
case _AuthState() when $default != null:
return $default(_that.countryCode,_that.phoneNumber,_that.otp,_that.isOtpSent,_that.resendTimer,_that.resendAttempt,_that.isLoading,_that.isOtpLoading,_that.isLoginLoading,_that.errorMessage,_that.verificationId,_that.resendToken,_that.firstName,_that.lastName,_that.email,_that.userType,_that.locationGranted,_that.notificationsGranted,_that.isAuthenticated);case _:
  return null;

}
}

}

/// @nodoc


class _AuthState extends AuthState {
  const _AuthState({this.countryCode = '+1', this.phoneNumber = '', this.otp = '', this.isOtpSent = false, this.resendTimer = 60, this.resendAttempt = 0, this.isLoading = false, this.isOtpLoading = false, this.isLoginLoading = false, this.errorMessage, this.verificationId, this.resendToken, this.firstName = '', this.lastName = '', this.email = '', this.userType = 'passenger', this.locationGranted = false, this.notificationsGranted = false, this.isAuthenticated = false}): super._();
  

@override@JsonKey() final  String countryCode;
@override@JsonKey() final  String phoneNumber;
@override@JsonKey() final  String otp;
@override@JsonKey() final  bool isOtpSent;
@override@JsonKey() final  int resendTimer;
@override@JsonKey() final  int resendAttempt;
@override@JsonKey() final  bool isLoading;
@override@JsonKey() final  bool isOtpLoading;
@override@JsonKey() final  bool isLoginLoading;
@override final  String? errorMessage;
@override final  String? verificationId;
@override final  int? resendToken;
@override@JsonKey() final  String firstName;
@override@JsonKey() final  String lastName;
@override@JsonKey() final  String email;
@override@JsonKey() final  String userType;
@override@JsonKey() final  bool locationGranted;
@override@JsonKey() final  bool notificationsGranted;
@override@JsonKey() final  bool isAuthenticated;

/// Create a copy of AuthState
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$AuthStateCopyWith<_AuthState> get copyWith => __$AuthStateCopyWithImpl<_AuthState>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _AuthState&&(identical(other.countryCode, countryCode) || other.countryCode == countryCode)&&(identical(other.phoneNumber, phoneNumber) || other.phoneNumber == phoneNumber)&&(identical(other.otp, otp) || other.otp == otp)&&(identical(other.isOtpSent, isOtpSent) || other.isOtpSent == isOtpSent)&&(identical(other.resendTimer, resendTimer) || other.resendTimer == resendTimer)&&(identical(other.resendAttempt, resendAttempt) || other.resendAttempt == resendAttempt)&&(identical(other.isLoading, isLoading) || other.isLoading == isLoading)&&(identical(other.isOtpLoading, isOtpLoading) || other.isOtpLoading == isOtpLoading)&&(identical(other.isLoginLoading, isLoginLoading) || other.isLoginLoading == isLoginLoading)&&(identical(other.errorMessage, errorMessage) || other.errorMessage == errorMessage)&&(identical(other.verificationId, verificationId) || other.verificationId == verificationId)&&(identical(other.resendToken, resendToken) || other.resendToken == resendToken)&&(identical(other.firstName, firstName) || other.firstName == firstName)&&(identical(other.lastName, lastName) || other.lastName == lastName)&&(identical(other.email, email) || other.email == email)&&(identical(other.userType, userType) || other.userType == userType)&&(identical(other.locationGranted, locationGranted) || other.locationGranted == locationGranted)&&(identical(other.notificationsGranted, notificationsGranted) || other.notificationsGranted == notificationsGranted)&&(identical(other.isAuthenticated, isAuthenticated) || other.isAuthenticated == isAuthenticated));
}


@override
int get hashCode => Object.hashAll([runtimeType,countryCode,phoneNumber,otp,isOtpSent,resendTimer,resendAttempt,isLoading,isOtpLoading,isLoginLoading,errorMessage,verificationId,resendToken,firstName,lastName,email,userType,locationGranted,notificationsGranted,isAuthenticated]);

@override
String toString() {
  return 'AuthState(countryCode: $countryCode, phoneNumber: $phoneNumber, otp: $otp, isOtpSent: $isOtpSent, resendTimer: $resendTimer, resendAttempt: $resendAttempt, isLoading: $isLoading, isOtpLoading: $isOtpLoading, isLoginLoading: $isLoginLoading, errorMessage: $errorMessage, verificationId: $verificationId, resendToken: $resendToken, firstName: $firstName, lastName: $lastName, email: $email, userType: $userType, locationGranted: $locationGranted, notificationsGranted: $notificationsGranted, isAuthenticated: $isAuthenticated)';
}


}

/// @nodoc
abstract mixin class _$AuthStateCopyWith<$Res> implements $AuthStateCopyWith<$Res> {
  factory _$AuthStateCopyWith(_AuthState value, $Res Function(_AuthState) _then) = __$AuthStateCopyWithImpl;
@override @useResult
$Res call({
 String countryCode, String phoneNumber, String otp, bool isOtpSent, int resendTimer, int resendAttempt, bool isLoading, bool isOtpLoading, bool isLoginLoading, String? errorMessage, String? verificationId, int? resendToken, String firstName, String lastName, String email, String userType, bool locationGranted, bool notificationsGranted, bool isAuthenticated
});




}
/// @nodoc
class __$AuthStateCopyWithImpl<$Res>
    implements _$AuthStateCopyWith<$Res> {
  __$AuthStateCopyWithImpl(this._self, this._then);

  final _AuthState _self;
  final $Res Function(_AuthState) _then;

/// Create a copy of AuthState
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? countryCode = null,Object? phoneNumber = null,Object? otp = null,Object? isOtpSent = null,Object? resendTimer = null,Object? resendAttempt = null,Object? isLoading = null,Object? isOtpLoading = null,Object? isLoginLoading = null,Object? errorMessage = freezed,Object? verificationId = freezed,Object? resendToken = freezed,Object? firstName = null,Object? lastName = null,Object? email = null,Object? userType = null,Object? locationGranted = null,Object? notificationsGranted = null,Object? isAuthenticated = null,}) {
  return _then(_AuthState(
countryCode: null == countryCode ? _self.countryCode : countryCode // ignore: cast_nullable_to_non_nullable
as String,phoneNumber: null == phoneNumber ? _self.phoneNumber : phoneNumber // ignore: cast_nullable_to_non_nullable
as String,otp: null == otp ? _self.otp : otp // ignore: cast_nullable_to_non_nullable
as String,isOtpSent: null == isOtpSent ? _self.isOtpSent : isOtpSent // ignore: cast_nullable_to_non_nullable
as bool,resendTimer: null == resendTimer ? _self.resendTimer : resendTimer // ignore: cast_nullable_to_non_nullable
as int,resendAttempt: null == resendAttempt ? _self.resendAttempt : resendAttempt // ignore: cast_nullable_to_non_nullable
as int,isLoading: null == isLoading ? _self.isLoading : isLoading // ignore: cast_nullable_to_non_nullable
as bool,isOtpLoading: null == isOtpLoading ? _self.isOtpLoading : isOtpLoading // ignore: cast_nullable_to_non_nullable
as bool,isLoginLoading: null == isLoginLoading ? _self.isLoginLoading : isLoginLoading // ignore: cast_nullable_to_non_nullable
as bool,errorMessage: freezed == errorMessage ? _self.errorMessage : errorMessage // ignore: cast_nullable_to_non_nullable
as String?,verificationId: freezed == verificationId ? _self.verificationId : verificationId // ignore: cast_nullable_to_non_nullable
as String?,resendToken: freezed == resendToken ? _self.resendToken : resendToken // ignore: cast_nullable_to_non_nullable
as int?,firstName: null == firstName ? _self.firstName : firstName // ignore: cast_nullable_to_non_nullable
as String,lastName: null == lastName ? _self.lastName : lastName // ignore: cast_nullable_to_non_nullable
as String,email: null == email ? _self.email : email // ignore: cast_nullable_to_non_nullable
as String,userType: null == userType ? _self.userType : userType // ignore: cast_nullable_to_non_nullable
as String,locationGranted: null == locationGranted ? _self.locationGranted : locationGranted // ignore: cast_nullable_to_non_nullable
as bool,notificationsGranted: null == notificationsGranted ? _self.notificationsGranted : notificationsGranted // ignore: cast_nullable_to_non_nullable
as bool,isAuthenticated: null == isAuthenticated ? _self.isAuthenticated : isAuthenticated // ignore: cast_nullable_to_non_nullable
as bool,
  ));
}


}

// dart format on
