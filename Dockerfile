FROM ruby:3.0.0-alpine
# update(インストールするパッケージを最新版に) & add(インストール) --no-cacheはインストール後にパッケージキャッシュを削除の意
RUN apk update && apk add --no-cache \
      bash \
      # rspecのsystem testに必要
      chromium \
      chromium-chromedriver \
      # 無いとsystem testで使用されるブラウザ上の日本語が□で表示される(これだけだとゴシック体のみ)
      font-noto-cjk \
      fontconfig \
      git \
      nodejs~=14 \
      postgresql-client \
      tzdata \
      yarn~=1 \
# --virtual=.build-depsでインストールするパッケージを名前空間に格納する。後のdelでまとめて指定できる。
&& apk update && apk add --no-cache --virtual=.build-deps \
      # gem pgインストール時に必要
      build-base \
      postgresql-dev \
&& fc-cache -fv \
# tzdataにより可能。行わないとTZInfo::DataSourceNotFoundとなる。
&& cp /usr/share/zoneinfo/Asia/Tokyo /etc/localtime
WORKDIR /proglog
COPY Gemfile /proglog/Gemfile
COPY Gemfile.lock /proglog/Gemfile.lock
RUN bundle install
# --virtualで指定したパッケージをまとめて削除。--purgeは関連ファイルもまとめて削除の意
RUN apk del --purge .build-deps
COPY . /proglog
COPY entrypoint.sh /usr/bin/
RUN chmod +x /usr/bin/entrypoint.sh
ENTRYPOINT ["entrypoint.sh"]
EXPOSE 3000
CMD ["bundle", "exec", "rails", "server", "-b", "0.0.0.0"]
