# n=5 model=out iset=I1 prefix14_class=1477
cmp P0, P3
mov S0, P2
mov S1, P0
cmovg S1, P3
cmovl P0, P3
mov S2, S1
cmp S0, P1
cmovle S0, P1
cmovle P1, P2
cmp S0, P0
cmovg P3, P0
cmovge P0, S0
cmovg S0, P3
cmp P1, S1
