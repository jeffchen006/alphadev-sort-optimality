# n=5 model=out iset=I1 prefix14_class=5777
mov S1, P3
cmp S1, P0
cmovge P3, P0
mov S2, P3
cmovle S1, P0
cmp P1, P2
cmovg S0, P2
cmovg P2, P1
cmovle S0, P1
cmp S0, S2
cmovl P3, S0
cmovg S2, S0
cmp S1, P2
cmovle P1, S1
