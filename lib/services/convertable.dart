import 'package:reflectable/capability.dart';
import 'package:reflectable/reflectable.dart';

/// A class that extends `Reflectable` to provide reflection capabilities.
///
/// The `Convertable` class is used to enable reflection on annotated classes.
/// It includes various capabilities such as instance invocation, declarations,
/// library access, type relations, metadata, type information, and more.
class Convertable extends Reflectable {
  /// Creates a new instance of `Convertable` with the specified capabilities.
  ///
  /// The capabilities include:
  /// - `instanceInvokeCapability`: Allows invoking instance methods.
  /// - `declarationsCapability`: Provides access to class declarations.
  /// - `libraryCapability`: Grants access to library-level information.
  /// - `typeRelationsCapability`: Enables querying type relations.
  /// - `metadataCapability`: Allows access to metadata annotations.
  /// - `typeCapability`: Provides type information.
  /// - `reflectedTypeCapability`: Grants access to reflected type information.
  /// - `newInstanceCapability`: Allows creating new instances.
  /// - `typeAnnotationQuantifyCapability`: Enables type annotation quantification.
  /// - `typeAnnotationDeepQuantifyCapability`: Enables deep type annotation quantification.
  const Convertable()
      : super(
            instanceInvokeCapability,
            declarationsCapability,
            typeRelationsCapability,
            metadataCapability,
            typeCapability,
            reflectedTypeCapability,
            newInstanceCapability,
            superclassQuantifyCapability,
            typeAnnotationQuantifyCapability,
            typeAnnotationDeepQuantifyCapability);
}

/// A constant instance of the `Convertable` class.
///
/// This instance can be used to annotate classes that require reflection capabilities.
const convertable = Convertable();
