# n=5 model=out iset=I1 prefix14_class=958
cmp P0, P2
mov S0, P0
cmovl S0, P2
cmovle P2, P0
cmp P1, P3
cmovge S2, P1
cmovg P1, P3
mov S1, S0
cmovg P3, S2
cmp P3, S1
cmovge S0, P3
cmovge P3, S1
cmp P1, P2
cmovle S2, P1
