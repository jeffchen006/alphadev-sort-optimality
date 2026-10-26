# n=5 model=out iset=I1 prefix14_class=9226
cmp P2, P1
cmovle S2, P2
cmovg S2, P1
mov S0, S2
cmovg P1, P2
cmp P0, P3
mov S1, P3
cmovl P3, P0
cmovge S1, P0
cmp S0, P3
cmovle S2, P3
cmovg S0, P3
cmp S1, P1
cmovge P0, S1
