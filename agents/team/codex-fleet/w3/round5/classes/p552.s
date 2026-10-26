# n=5 model=out iset=I1 prefix14_class=552
cmp P0, P3
cmovge S0, P0
mov S1, P1
cmovg P0, P3
cmovg P3, S0
cmp P1, P2
cmovl P1, P2
cmovge S1, P2
mov S2, S1
cmp P0, S2
cmovg S2, P0
cmovle S1, P0
cmp P1, P3
mov P0, P3
