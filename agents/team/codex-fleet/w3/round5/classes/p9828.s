# n=5 model=out iset=I1 prefix14_class=9828
cmp P3, P0
mov S1, P0
cmovl S1, P3
cmovg P0, P3
cmp P2, P1
mov P3, P2
cmovle P2, P1
cmovge P3, P1
mov P1, P3
cmp P2, P0
cmovle S0, P2
cmovle P2, P0
cmovle P0, S0
cmp P1, S1
