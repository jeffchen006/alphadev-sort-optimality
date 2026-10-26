# n=5 model=out iset=I1 prefix14_class=3208
mov S1, P0
cmp P2, S1
cmovl P0, P2
cmovg S1, P2
cmp P1, P3
mov S0, P3
cmovge P3, P1
cmovge P1, S0
cmovle S0, P1
cmp P0, S0
cmovge P1, P0
cmovg P0, S0
cmp S1, P3
cmovge P2, S1
