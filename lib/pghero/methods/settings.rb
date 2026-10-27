module PgHero
  module Methods
    module Settings
      def settings
        names =
          if server_version_num >= 180000
            %i(
              max_connections shared_buffers effective_cache_size maintenance_work_mem
              checkpoint_completion_target wal_buffers default_statistics_target
              random_page_cost effective_io_concurrency work_mem huge_pages
              jit wal_compression io_method min_wal_size max_wal_size
            )
          else
            %i(
              max_connections shared_buffers effective_cache_size maintenance_work_mem
              checkpoint_completion_target wal_buffers default_statistics_target
              random_page_cost effective_io_concurrency work_mem huge_pages
              jit wal_compression min_wal_size max_wal_size
            )
          end
        fetch_settings(names)
      end

      def autovacuum_settings
        fetch_settings %i(autovacuum autovacuum_max_workers autovacuum_vacuum_cost_limit autovacuum_vacuum_scale_factor autovacuum_analyze_scale_factor)
      end

      def vacuum_settings
        fetch_settings %i(vacuum_cost_limit)
      end

      private

      def fetch_settings(names)
        names.to_h { |name| [name, select_one("SHOW #{name}")] }
      end
    end
  end
end
