# n=5 model=out iset=I1 prefix14_class=9911
mov S0, P1
cmp S0, P3
cmovg P1, P3
cmovg P3, S0
mov S2, P3
mov S1, P2
cmp P2, P0
cmovle S1, P0
cmovge P2, P0
cmp S1, S2
cmovl P3, S1
cmovge S2, S1
cmp P2, P1
cmovg S0, P2
