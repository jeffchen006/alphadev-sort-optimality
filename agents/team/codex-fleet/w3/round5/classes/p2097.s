# n=5 model=out iset=I1 prefix14_class=2097
cmp P0, P3
cmovg S0, P3
cmovle S0, P0
mov S2, P1
cmovge P3, P0
cmp S2, P2
cmovge S2, P2
cmovle P1, P2
cmp P3, P1
cmovg S1, P3
cmovg P3, P1
cmovle S1, P1
cmp S0, S2
cmovl P2, S0
