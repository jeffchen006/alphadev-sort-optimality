# n=5 model=out iset=I1 prefix14_class=14420
mov S0, P2
mov S1, P3
cmp P0, S0
cmovle S0, P0
cmovle P0, P2
cmp S1, P1
cmovl P3, P1
cmovl P1, S1
cmp P1, S0
cmovg P2, P1
mov S2, P3
cmovge P1, S0
cmovg S0, P2
cmp S2, P0
