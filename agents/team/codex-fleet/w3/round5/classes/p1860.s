# n=5 model=out iset=I1 prefix14_class=1860
mov S2, P1
mov S1, P3
cmp P2, S2
cmovl P1, P2
cmovg S2, P2
cmp P0, S1
cmovge P3, P0
cmovg P0, S1
mov S0, P3
cmp S0, S2
cmovle S0, S2
cmovle S2, P3
cmp P0, P1
cmovle S0, P0
