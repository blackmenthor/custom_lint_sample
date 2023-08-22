// This is the entrypoint of our custom linter
import 'package:analyzer/error/listener.dart';
import 'package:custom_lint_builder/custom_lint_builder.dart';

PluginBase createPlugin() => CustomLinter();

/// A plugin class is used to list all the assists/lints defined by a plugin.
class CustomLinter extends PluginBase {
  /// We list all the custom warnings/infos/errors
  @override
  List<LintRule> getLintRules(CustomLintConfigs configs) => [
        const BlocLintRule(),
      ];
}

class BlocLintRule extends DartLintRule {
  const BlocLintRule() : super(code: _code);

  static const _code = LintCode(
    name: 'bloc_lint_rule',
    problemMessage: 'Kelas Bloc tidak diakhiri dengan kata Bloc!',
  );

  @override
  void run(
    CustomLintResolver resolver,
    ErrorReporter reporter,
    CustomLintContext context,
  ) {
    context.registry.addClassDeclaration((node) {
      // class declaration
      // cek apakah class tersebut extends Bloc atau Cubit
      if (node.extendsClause != null) {
        final superclass = node.extendsClause!.superclass.type.toString();
        if (superclass.startsWith('Bloc') || superclass.startsWith('Cubit')) {
          final nodeName = node.name.toString();

          if (!nodeName.endsWith('Bloc')) {
            reporter.reportErrorForNode(_code, node);
          }
        }
      }
    });
  }
}
