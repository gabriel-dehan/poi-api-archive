SegmentAnalytics = Segment::Analytics.new({
    write_key: ENV['SEGMENT_API_KEY'],
    on_error: Proc.new { |status, msg| puts "[SEGMENT ERROR] #{msg}" }
})

module Analytics
    def self.identify(*args)
        unless ThreadedConfig.is_silent?
            SegmentAnalytics.identify(*args)
        end
    end

    def self.track(*args)
        unless ThreadedConfig.is_silent?
            SegmentAnalytics.track(*args)
        end
    end
end