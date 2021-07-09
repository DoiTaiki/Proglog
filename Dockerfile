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
      #freetype \
      git \
      nodejs~=14 \
      postgresql-client \
      #ttf-freefont \
      tzdata \
      yarn~=1 \
# --virtual=.build-depsでインストールするパッケージを名前空間に格納する。後のdelでまとめて指定できる。
&& apk update && apk add --no-cache --virtual=.build-deps \
      # gem pgインストール時に必要
      build-base \
      postgresql-dev \
      # pip installコマンドに必要
      #python3 \
      #python3-dev \
      #py3-pip \
# 日本語フォント(Sans-serif)のダウンロード
#&& mkdir noto \
#&& wget -P /noto https://noto-website.storage.googleapis.com/pkgs/NotoSansCJKjp-hinted.zip \
#&& wget -P /noto https://noto-website-2.storage.googleapis.com/pkgs/NotoSerifCJKjp-hinted.zip \
#&& unzip /noto/NotoSansCJKjp-hinted.zip -d /noto \
#&& unzip -o /noto/NotoSerifCJKjp-hinted.zip -d /noto \
#&& mkdir -p /usr/share/fonts/noto \
#&& cp /noto/*.otf /usr/share/fonts/noto \
#&& chmod 644 -R /usr/share/fonts/noto/ \
#&& rm -rf /noto \
&& fc-cache -fv \
# tzdataにより可能。行わないとTZInfo::DataSourceNotFoundとなる。
&& cp /usr/share/zoneinfo/Asia/Tokyo /etc/localtime
#&& pip3 install -U selenium
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
