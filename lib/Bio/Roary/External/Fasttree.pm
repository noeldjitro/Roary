package Bio::Roary::External::Fasttree;

# ABSTRACT: Wrapper to run Fasttree

=head1 SYNOPSIS

Wrapper to run cd-hit
   use Bio::Roary::External::Fasttree;
   
   my $obj = Bio::Roary::External::Fasttree->new(
     input_file   => 'abc.fa',
     exec         => 'Fasttree',
     output_base  => 'efg',
   );
  $obj->run;

=cut

use Moose;
with 'Bio::Roary::JobRunner::Role';

has 'input_file'                   => ( is => 'ro', isa => 'Str',  required => 1 );
has 'output_file'                  => ( is => 'ro', isa => 'Str',  default  => 'output.tre' );
has 'exec'                         => ( is => 'ro', isa => 'Str',  default  => 'FastTree' );
has 'alt_exec'                     => ( is => 'ro', isa => 'Str',  default  => 'fasttree' );


sub _command_to_run {
    my ($self) = @_;

	my $executable = $self->_find_exe([$self->exec, $self->alt_exec]);

    return join(
        ' ', ($executable, '-fastest', '-nt', $self->input_file, '>', $self->output_file)
    );
}

sub run {
    my ($self) = @_;
    my @commands_to_run;
	
    push(@commands_to_run, $self->_command_to_run() );
    
    my $job_runner_obj = $self->_job_runner_class->new( commands_to_run => \@commands_to_run, memory_in_mb => $self->_memory_required_in_mb, queue => $self->_queue, cpus => $self->cpus );
    $job_runner_obj->run();
    
    1;
}

no Moose;
__PACKAGE__->meta->make_immutable;

1;
