const CleanWebpackPlugin = require('clean-webpack-plugin').CleanWebpackPlugin
const HtmlWebpackPlugin = require('html-webpack-plugin')
const MiniCssExtractPlugin = require('mini-css-extract-plugin')
const path = require('path')

module.exports = env => {

  const isProduction = env.NODE_ENV === "production";

  return {
    mode: isProduction ? "production" : "development",
    context: path.resolve(__dirname, 'src'),
    entry: './index.js',
    output: {
      path: path.resolve(__dirname, 'dist'),
      publicPath: '/',
      filename: '[name].bundle.js',
    },
    module: {
      rules: [
        {
          test: /\.elm$/,
          exclude: [/elm-stuff/, /node_modules/],
          loader: 'elm-webpack-loader',
          options: {
            pathToElm: path.resolve(__dirname, 'node_modules/.bin/elm'),
            debug: !isProduction,
            forceWatch: true,
            runtimeOptions: ['-A128M', '-H128M', '-n8m']
          }
        },
        {
          test: /\.(js|jsx)$/,
          exclude: /node_modules/,
          use: ['babel-loader?cacheDirectory=true']
        },
        {
          test: /\.css$/,
          use: ['style-loader', 'css-loader?url=false']
        },
        {
          test: /\.scss$/,
          use: [
            {
              loader: MiniCssExtractPlugin.loader
            },
            {
              loader: 'css-loader',
            },
            {
              loader: 'sass-loader',
              options: {
                sourceMap: !isProduction
              }
            }
          ]
        },
        {
          test: /\.(jpe?g|svg|png|gif|webp|otf|ttf|eot|woff(2)?)(\?[a-z0-9=&.]+)?$/,
          loader: 'file-loader',
          options: { name: '[name].[ext]', outputPath: 'assets' }
        },
      ]
    },
    plugins: [
      new CleanWebpackPlugin(),
      new HtmlWebpackPlugin({
        template: 'index.html'
      }),
      new MiniCssExtractPlugin()
    ],
    devServer: {
      contentBase: path.join(__dirname, 'dist'),
      compress: true,
      port: 10080,
      hot: true,
      publicPath: '/',
      historyApiFallback: true,
      overlay: true,
    }
  }
}
