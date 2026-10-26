# n=5 model=out iset=I1 prefix14_class=4842
mov S2, P2
cmp P3, S2
cmovle P2, P3
cmovge S2, P3
cmp P1, P0
mov S0, P1
cmovg P1, P0
cmovg P0, S0
cmp P1, P2
cmovle P3, P2
cmovg P3, P1
cmovl P2, P1
cmp P0, S2
cmovl S1, S2
