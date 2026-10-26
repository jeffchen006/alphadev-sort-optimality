# n=5 model=out iset=I1 prefix14_class=9513
cmp P3, P2
cmovg S2, P2
cmovle S2, P3
cmovl P3, P2
cmp P1, P0
cmovg S0, P1
cmovge P1, P0
cmovg P0, S0
cmp S2, P1
cmovge S0, S2
cmovg S2, P1
cmovg P1, S0
mov S2, P3
cmp P3, P0
