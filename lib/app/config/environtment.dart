import 'package:flutter_dotenv/flutter_dotenv.dart';

var baseUrl = dotenv.env['baseUrl'] ?? '';

var giphyKey = dotenv.env['giphyKey'];
var awsAccessKeyId = dotenv.env['AWS_ACCESS_KEY_ID'];
var awsSecretAccessKey = dotenv.env['AWS_SECRET_ACCESS_KEY'];
var awsRegion = dotenv.env['AWS_REGION'];
var s3Bucket = dotenv.env['S3_BUCKET'];
var tmpFolder = dotenv.env['TMP_FOLDER'];
