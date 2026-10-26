# n=5 model=out iset=I1 prefix14_class=14244
mov S0, P1
mov S1, P2
cmp P3, P2
cmovge S1, P3
cmovg P3, P2
cmp P0, P1
mov S2, S1
cmovg S0, P0
cmovl P1, P0
cmp S1, S0
cmovg S2, S0
cmovge S0, S1
cmp P1, P3
cmovg S1, P3
