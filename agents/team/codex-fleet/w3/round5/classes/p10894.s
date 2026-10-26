# n=5 model=out iset=I1 prefix14_class=10894
cmp P2, P1
mov S0, P1
cmovge P1, P2
cmovle S0, P2
cmp P3, P0
cmovg S2, P0
cmovg P0, P3
mov S1, P0
cmovg P3, S2
cmp S1, P1
cmovle P0, P1
cmovl P1, S1
cmp S0, P3
cmovle S1, P3
