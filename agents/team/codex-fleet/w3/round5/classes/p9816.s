# n=5 model=out iset=I1 prefix14_class=9816
cmp P3, P1
cmovl S0, P1
cmovge S0, P3
cmovge P3, P1
cmp P0, P2
cmovle S2, P2
cmovle P2, P0
mov P1, S0
cmovle P0, S2
cmp P0, S0
cmovg P1, P0
cmovg P0, S0
cmp P2, P3
cmovge P1, P2
