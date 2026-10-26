# n=5 model=out iset=I1 prefix14_class=10384
cmp P3, P2
mov S0, P0
cmovg S1, P3
cmovge P3, P2
cmovle S1, P2
cmp P1, S0
cmovg S0, P1
mov S2, S1
cmovle P0, P1
cmp S1, S0
cmovg S2, S0
cmovle S1, S0
cmp P3, P0
cmovl P1, P3
