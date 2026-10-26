# n=5 model=out iset=I1 prefix14_class=5380
cmp P2, P0
cmovle S2, P0
mov S0, P1
cmovl P0, P2
cmovle P2, S2
cmp S0, P3
cmovg S0, P3
cmovl P1, P3
mov P3, P0
cmp S0, P3
cmovl P3, S0
cmovg P0, S0
cmp P1, P2
cmovle S0, P2
