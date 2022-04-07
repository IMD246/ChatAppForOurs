import 'package:bloc/bloc.dart';
import 'package:chatappforours/services/bloc/validator/check_format_field_event.dart';
import 'package:chatappforours/services/bloc/validator/check_format_field_state.dart';
import 'package:chatappforours/utilities/validator/check_format_field.dart';

class CheckFormatFieldBloc
    extends Bloc<CheckFormatFieldEvent, CheckFormatFieldState> {
  CheckFormatFieldBloc() : super(const CheckFormatFieldEmailState('')) {
    on<CheckFormatEmailFieldEvent>(
      (event, emit) {
        final errorString = checkFormatEmail(event.value);
        if (errorString.isNotEmpty) {
          emit(
            CheckFormatFieldEmailState(errorString),
          );
        }
      },
    );
    on<CheckFormatPasswordFieldEvent>(
      (event, emit) {
        final errorString = checkPassword(event.value);
        emit(
          CheckFormatFieldPasswordState(errorString),
        );
      },
    );
    on<CheckFormatNameFieldEvent>(
      (event, emit) {
        final errorString = checkName(event.value);
        emit(
          CheckFormatFieldNameState(errorString),
        );
      },
    );
  }
}
