# n=5 model=out iset=I1 prefix14_class=10949
mov S0, P0
cmp P1, P0
cmovl P0, P1
cmovle P1, S0
cmp P2, P3
cmovg S1, P2
cmovge P2, P3
cmovg P3, S1
mov S0, P1
cmp P3, S0
cmovg P1, P3
cmovl S0, P3
cmp P0, P2
cmovle P3, P2
