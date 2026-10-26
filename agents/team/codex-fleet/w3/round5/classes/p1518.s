# n=5 model=out iset=I1 prefix14_class=1518
cmp P3, P2
mov S0, P2
cmovge P2, P3
cmovle S0, P3
cmp P1, P0
mov S2, P1
cmovge S2, P0
cmovg P0, P1
cmp S0, S2
cmovge P1, S0
cmovge S0, S2
cmovg S2, P1
cmp P0, P2
cmovl P3, P0
