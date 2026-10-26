# n=5 model=out iset=I1 prefix14_class=12750
cmp P3, P2
cmovl S0, P3
mov S2, P1
cmovge S0, P2
cmovg P2, P3
cmp P1, P0
cmovle P1, P0
cmovl P0, S2
mov S1, S0
cmp P0, S1
cmovg S1, P0
cmovle S0, P0
cmp P1, P2
cmovge S2, P2
