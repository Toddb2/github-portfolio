import React from 'react';
import { Card, CardContent, Typography } from '@mui/material';
import { isAfter, subWeeks, parseISO } from 'date-fns';
import './AnalyticsWindow.css';

const AnalyticsWindow = ({ tasks }) => {
  const oneWeekAgo = subWeeks(new Date(), 1);
  const lastWeeksTasks = tasks.filter(task =>
    isAfter(parseISO(task.dueDate), oneWeekAgo)
  );

  return (
    <Card className="analytics-window">
      <CardContent>
        <Typography variant="h6">Last Week's Tasks</Typography>
        <Typography variant="body2">
          {lastWeeksTasks.length} tasks due within the last week.
        </Typography>
        {/* Additional analytics can be added here */}
      </CardContent>
    </Card>
  );
};

export default AnalyticsWindow;