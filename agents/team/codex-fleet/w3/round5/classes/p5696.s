# n=5 model=out iset=I1 prefix14_class=5696
cmp P1, P3
mov S0, P0
mov S2, P1
cmovg P1, P3
cmovge P3, S2
cmp P0, P2
mov S2, P1
cmovg S0, P2
cmovge P2, P0
cmp S0, P1
cmovl P1, S0
cmovle S0, S2
cmp P3, P2
cmovl S2, P3
