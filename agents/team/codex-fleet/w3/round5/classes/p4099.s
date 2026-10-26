# n=5 model=out iset=I1 prefix14_class=4099
mov S0, P2
cmp P3, P2
cmovl P2, P3
mov S2, P0
cmovg S0, P3
cmp P1, S2
cmovge P0, P1
cmovge P1, S2
cmp P2, P1
cmovge P3, P1
cmovg P1, P2
cmovg P2, P3
cmp P0, S0
mov S2, S0
