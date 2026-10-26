# n=5 model=out iset=I1 prefix14_class=9590
cmp P1, P0
cmovle S0, P0
cmovl P0, P1
cmovge S0, P1
mov S2, P3
cmp P2, P3
cmovge P3, P2
cmovge P2, S2
cmp S0, P3
mov P1, S0
cmovg S0, P3
cmovg P3, P1
cmp P0, P2
cmovge P1, P0
