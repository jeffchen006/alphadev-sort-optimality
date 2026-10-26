# n=5 model=out iset=I1 prefix14_class=9403
mov S0, P2
cmp P1, P2
cmovge S0, P1
mov S2, P3
cmovge P1, P2
cmp P0, S2
cmovle S2, P0
cmovl P0, P3
cmp P1, S2
cmovg P2, P1
cmovg P1, S2
cmovg S2, P2
cmp S0, P0
mov S1, S2
