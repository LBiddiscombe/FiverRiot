/*!
 * Copyright 2016 Google Inc. All rights reserved.
 *
 * Licensed under the Apache License, Version 2.0 (the "License");
 * you may not use this file except in compliance with the License.
 * You may obtain a copy of the License at
 *
 * http://www.apache.org/licenses/LICENSE-2.0
 *
 * Unless required by applicable law or agreed to in writing, software
 * distributed under the License is distributed on an "AS IS" BASIS,
 * WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express
 * or implied. See the License for the specific language governing
 * permissions and limitations under the License.
 */
!(function t(e, n, i) {
  function r(a, o) {
    if (!n[a]) {
      if (!e[a]) {
        var l = 'function' == typeof require && require
        if (!o && l) return l(a, !0)
        if (s) return s(a, !0)
        var u = new Error("Cannot find module '" + a + "'")
        throw ((u.code = 'MODULE_NOT_FOUND'), u)
      }
      var f = (n[a] = { exports: {} })
      e[a][0].call(
        f.exports,
        function(t) {
          var n = e[a][1][t]
          return r(n ? n : t)
        },
        f,
        f.exports,
        t,
        e,
        n,
        i
      )
    }
    return n[a].exports
  }
  for (
    var s = 'function' == typeof require && require, a = 0;
    a < i.length;
    a++
  )
    r(i[a])
  return r
})(
  {
    1: [
      function(t, e, n) {
        'use strict'
        function i(t, e) {
          if (!(t instanceof e))
            throw new TypeError('Cannot call a class as a function')
        }
        var r = (function() {
          function t(t, e) {
            for (var n = 0; n < e.length; n++) {
              var i = e[n]
              ;(i.enumerable = i.enumerable || !1),
                (i.configurable = !0),
                'value' in i && (i.writable = !0),
                Object.defineProperty(t, i.key, i)
            }
          }
          return function(e, n, i) {
            return n && t(e.prototype, n), i && t(e, i), e
          }
        })()
        Object.defineProperty(n, '__esModule', { value: !0 })
        var s = (function() {
          function t() {
            var e = this,
              n =
                arguments.length <= 0 || void 0 === arguments[0]
                  ? {}
                  : arguments[0]
            i(this, t)
            var r = {
                duration: 330,
                delay: 0,
                easing: function(t) {
                  return t
                },
                transform: !0,
                opacity: !0,
                play: 'rAF'
              },
              s = Object.assign({}, r, n)
            if ('undefined' == typeof s.element)
              throw new Error('Element must be provided.')
            if ('function' != typeof s.easing) {
              if ('undefined' == typeof s.easing.getRatio)
                throw new Error('Easing function must be provided.')
              s.easing = s.easing.getRatio
            }
            ;(this.element_ = s.element),
              (this.first_ = { layout: null, opacity: 0 }),
              (this.last_ = { layout: null, opacity: 0 }),
              (this.invert_ = { x: 0, y: 0, sx: 1, sy: 1, a: 0 }),
              (this.start_ = 0),
              (this.duration_ = s.duration),
              (this.delay_ = s.delay),
              (this.easing_ = s.easing),
              (this.updateTransform_ = s.transform),
              (this.updateOpacity_ = s.opacity)
            var a = t.players_[s.play]
            if ('undefined' == typeof a)
              throw new Error('Unknown player type: ' + s.play)
            var o = Object.keys(a),
              l = void 0
            o.forEach(function(t) {
              ;(l = a[t]), (e[t] = l.bind(e))
            })
          }
          return (
            r(t, null, [
              {
                key: 'extend',
                value: function(t, e) {
                  'undefined' == typeof this.players_ && (this.players_ = {}),
                    'undefined' != typeof this.players_[t] &&
                      console.warn('Player with name ' + t + ' already exists'),
                    'undefined' == typeof e.play_ &&
                      console.warn(
                        'Player does not contain a play_() function'
                      ),
                    (this.players_[t] = e)
                }
              },
              {
                key: 'group',
                value: function(e) {
                  if (!Array.isArray(e))
                    throw new Error('group() expects an array of objects.')
                  return (
                    (e = e.map(function(e) {
                      return new t(e)
                    })),
                    {
                      flips_: e,
                      addClass: function(t) {
                        e.forEach(function(e) {
                          return e.addClass(t)
                        })
                      },
                      removeClass: function(t) {
                        e.forEach(function(e) {
                          return e.removeClass(t)
                        })
                      },
                      first: function() {
                        e.forEach(function(t) {
                          return t.first()
                        })
                      },
                      last: function(t) {
                        e.forEach(function(e, n) {
                          var i = t
                          Array.isArray(t) && (i = t[n]),
                            'undefined' != typeof i &&
                              e.element_.classList.add(i)
                        }),
                          e.forEach(function(t) {
                            return t.last()
                          })
                      },
                      invert: function() {
                        e.forEach(function(t) {
                          return t.invert()
                        })
                      },
                      play: function(t) {
                        'undefined' == typeof t &&
                          (t = window.performance.now()),
                          e.forEach(function(e) {
                            return e.play(t)
                          })
                      }
                    }
                  )
                }
              },
              {
                key: 'version',
                get: function() {
                  return '0.1.9'
                }
              }
            ]),
            r(t, [
              {
                key: 'addClass',
                value: function(t) {
                  'string' == typeof t && this.element_.classList.add(t)
                }
              },
              {
                key: 'removeClass',
                value: function(t) {
                  'string' == typeof t && this.element_.classList.remove(t)
                }
              },
              {
                key: 'snapshot',
                value: function(t) {
                  this.first(), this.last(t), this.invert()
                }
              },
              {
                key: 'first',
                value: function() {
                  ;(this.first_.layout = this.element_.getBoundingClientRect()),
                    (this.first_.opacity = parseFloat(
                      window.getComputedStyle(this.element_).opacity
                    ))
                }
              },
              {
                key: 'last',
                value: function(t) {
                  'undefined' != typeof t && this.addClass(t),
                    (this.last_.layout = this.element_.getBoundingClientRect()),
                    (this.last_.opacity = parseFloat(
                      window.getComputedStyle(this.element_).opacity
                    ))
                }
              },
              {
                key: 'invert',
                value: function() {
                  var t = []
                  if (null === this.first_.layout)
                    throw new Error('You must call first() before invert()')
                  if (null === this.last_.layout)
                    throw new Error('You must call last() before invert()')
                  ;(this.invert_.x =
                    this.first_.layout.left - this.last_.layout.left),
                    (this.invert_.y =
                      this.first_.layout.top - this.last_.layout.top),
                    (this.invert_.sx =
                      this.first_.layout.width / this.last_.layout.width),
                    (this.invert_.sy =
                      this.first_.layout.height / this.last_.layout.height),
                    (this.invert_.a = this.last_.opacity - this.first_.opacity),
                    this.updateTransform_ &&
                      ((this.element_.style.transformOrigin = '0 0'),
                      (this.element_.style.transform =
                        'translate(' +
                        this.invert_.x +
                        'px, ' +
                        this.invert_.y +
                        'px)\n           scale(' +
                        this.invert_.sx +
                        ', ' +
                        this.invert_.sy +
                        ')'),
                      t.push('transform')),
                    this.updateOpacity_ &&
                      ((this.element_.style.opacity = this.first_.opacity),
                      t.push('opacity')),
                    (this.element_.style.willChange = t.join(','))
                }
              },
              {
                key: 'play',
                value: function(t) {
                  if (null === this.invert_)
                    throw new Error('invert() must be called before play()')
                  if ('undefined' == typeof this.play_)
                    throw new Error('No player specified.')
                  this.play_(t)
                }
              },
              {
                key: 'fire_',
                value: function(t) {
                  var e =
                      arguments.length <= 1 || void 0 === arguments[1]
                        ? null
                        : arguments[1],
                    n =
                      arguments.length <= 2 || void 0 === arguments[2]
                        ? !0
                        : arguments[2],
                    i =
                      arguments.length <= 3 || void 0 === arguments[3]
                        ? !0
                        : arguments[3],
                    r = new CustomEvent(t, {
                      detail: e,
                      bubbles: n,
                      cancelable: i
                    })
                  this.element_.dispatchEvent(r)
                }
              },
              {
                key: 'clamp_',
                value: function(t) {
                  var e =
                      arguments.length <= 1 || void 0 === arguments[1]
                        ? Number.NEGATIVE_INFINITY
                        : arguments[1],
                    n =
                      arguments.length <= 2 || void 0 === arguments[2]
                        ? Number.POSITIVE_INFINITY
                        : arguments[2]
                  return Math.min(n, Math.max(e, t))
                }
              },
              {
                key: 'cleanUpAndFireEvent_',
                value: function() {
                  this.removeTransformsAndOpacity_(),
                    this.resetFirstLastAndInvertValues_(),
                    this.fire_('flipComplete')
                }
              },
              {
                key: 'removeTransformsAndOpacity_',
                value: function() {
                  ;(this.element_.style.transformOrigin = null),
                    (this.element_.style.transform = null),
                    (this.element_.style.opacity = null),
                    (this.element_.style.willChange = null)
                }
              },
              {
                key: 'resetFirstLastAndInvertValues_',
                value: function() {
                  ;(this.first_.layout = null),
                    (this.first_.opacity = 0),
                    (this.last_.layout = null),
                    (this.last_.opacity = 0),
                    (this.invert_.x = 0),
                    (this.invert_.y = 0),
                    (this.invert_.sx = 1),
                    (this.invert_.sy = 1),
                    (this.invert_.a = 0)
                }
              }
            ]),
            t
          )
        })()
        n['default'] = s
      },
      {}
    ],
    2: [
      function(t, e, n) {
        'use strict'
        function i(t) {
          return t && t.__esModule ? t : { default: t }
        }
        var r = t('./core'),
          s = i(r),
          a = t('./raf'),
          o = i(a),
          l = t('./gsap'),
          u = i(l)
        s['default'].extend('rAF', o['default']),
          s['default'].extend('GSAP', u['default']),
          'undefined' == typeof window.Core
            ? (window.FLIP = s['default'])
            : console.warn('FLIP already exists')
      },
      { './core': 1, './gsap': 3, './raf': 4 }
    ],
    3: [
      function(t, e, n) {
        'use strict'
        Object.defineProperty(n, '__esModule', { value: !0 }),
          (n['default'] = {
            play_: function(t) {
              var e = (t || window.performance.now()) / 1e3,
                n = !0,
                i = !0,
                r = null
              if (i) r = TweenMax
              else {
                if (!n)
                  throw new Error(
                    'GSAP requested, but TweenMax/Lite not available.'
                  )
                r = TweenLite
              }
              var s = {
                ease: this.easing_,
                onComplete: this.cleanUpAndFireEvent_.bind(this)
              }
              this.updateTransform_ &&
                Object.assign(s, { scaleX: 1, scaleY: 1, x: 0, y: 0 }),
                this.updateOpacity_ &&
                  Object.assign(s, { opacity: this.last_.opacity })
              var a = new r(this.element_, this.duration_ / 1e3, s)
              a.startTime(e + this.delay_ / 1e3)
            }
          })
      },
      {}
    ],
    4: [
      function(t, e, n) {
        'use strict'
        Object.defineProperty(n, '__esModule', { value: !0 }),
          (n['default'] = {
            play_: function(t) {
              'undefined' == typeof t
                ? (this.start_ = window.performance.now() + this.delay_)
                : (this.start_ = t + this.delay_),
                requestAnimationFrame(this.update_)
            },
            update_: function() {
              var t = (window.performance.now() - this.start_) / this.duration_
              t = this.clamp_(t, 0, 1)
              var e = this.easing_(t),
                n = {
                  x: this.invert_.x * (1 - e),
                  y: this.invert_.y * (1 - e),
                  sx: this.invert_.sx + (1 - this.invert_.sx) * e,
                  sy: this.invert_.sy + (1 - this.invert_.sy) * e,
                  a: this.first_.opacity + this.invert_.a * e
                }
              this.updateTransform_ &&
                (this.element_.style.transform =
                  'translate(' +
                  n.x +
                  'px, ' +
                  n.y +
                  'px)\n         scale(' +
                  n.sx +
                  ', ' +
                  n.sy +
                  ')'),
                this.updateOpacity_ && (this.element_.style.opacity = n.a),
                1 > t
                  ? requestAnimationFrame(this.update_)
                  : this.cleanUpAndFireEvent_()
            }
          })
      },
      {}
    ]
  },
  {},
  [2]
)