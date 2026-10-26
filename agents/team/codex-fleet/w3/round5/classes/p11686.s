# n=5 model=out iset=I1 prefix14_class=11686
cmp P1, P3
mov S2, P1
cmovle P1, P3
cmovle P3, S2
mov S1, P0
cmp P2, S1
cmovg P0, P2
cmovl S1, P2
cmp P1, P0
cmovle S0, P0
cmovl P0, P1
cmovle P1, S0
cmp P3, S1
cmovge P1, P3
