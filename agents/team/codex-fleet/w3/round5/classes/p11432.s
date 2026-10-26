# n=5 model=out iset=I1 prefix14_class=11432
mov S0, P0
cmp P0, P3
cmovle S0, P3
cmovge P0, P3
cmp P2, P1
cmovge P3, P2
cmovge P2, P1
cmovg P1, P3
cmp P2, P0
cmovg S2, P2
cmovle S2, P0
cmovl P0, P2
mov S1, S2
cmp S0, P1
