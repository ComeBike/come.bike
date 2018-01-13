const path = require('path');
const webpack = require('webpack');
const CopyWebpackPlugin = require('copy-webpack-plugin');
const ExtractTextPlugin = require('extract-text-webpack-plugin');
const CleanWebpackPlugin = require('clean-webpack-plugin')

module.exports = {
  entry: {
    app: './js/app.js',
    vendors: './js/vendors.js'
  },

  output: {
    path: path.join(__dirname, "../priv/static/js"),
    filename: '[name].js'
  },

  module: {
    rules: [{
        test: /\.css$/,
        use: ExtractTextPlugin.extract({
          fallback: "style-loader",
          use: [{
            loader: "css-loader" // translates CSS into CommonJS
          }]
        })
      }, {
        test: /\.scss$/,
        use: ExtractTextPlugin.extract({
          fallback: "style-loader",
          use: [{
            loader: "css-loader" // translates CSS into CommonJS
          }, {
            loader: "sass-loader" // compiles Sass to CSS
          }]
        })
      }, {
        test: /\.js$/,
        exclude: [/node_modules/],
        loader: 'babel-loader',
        query: {
          presets: ['env']
        }
      }//,
      // {
      //   test: /.(ttf|otf|eot|svg|woff(2)?)(\?[a-z0-9]+)?$/,
      //   use: [{
      //     loader: 'file-loader',
      //     options: {
      //       name: '[name].[ext]',
      //       outputPath: '../fonts/',
      //       publicPath: '../fonts/'
      //     }
      //   }]
      // },
    ]
  },

  plugins: [

    new webpack.ProvidePlugin({
      $: 'jquery',
      jQuery: 'jquery',
      'window.jQuery': 'jquery',
      moment: 'moment',
      Popper: ['popper.js', 'default']
    }),

    new CopyWebpackPlugin([
      {
        from: './static/',
        to: "../"
      },
      {
        from: './static/OneSignalSDKUpdaterWorker.js',
        to: '../OneSignalSDKUpdaterWorker.js'
      },
      {
        from: './static/OneSignalSDKWorker.js',
        to: '../OneSignalSDKWorker.js'
      },
      {
        from: './static/manifest.json',
        to: '../manifest.json'
      }
    ]),

    new ExtractTextPlugin('../css/[name].css'),

    new webpack.optimize.CommonsChunkPlugin({
      names: ['vendors', 'manifest'],
      filename: '[name].js'
    }),

    new CleanWebpackPlugin(["../priv/static"])
  ]
}
