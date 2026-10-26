# n=5 model=out iset=I1 prefix14_class=9734
cmp P1, P2
mov S1, P2
cmovg P2, P1
cmovle S1, P1
cmp P0, P3
mov S2, P0
cmovl P0, P3
cmovle P3, S2
cmp P2, P0
cmovge S2, P2
cmovge P2, P0
cmovge P0, S2
mov S0, P3
cmp S0, S1
